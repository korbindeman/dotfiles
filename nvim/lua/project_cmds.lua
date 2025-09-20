-- lua/project_cmds.lua
local M = {}

-- -------- utils --------
local function project_root()
	local buf = 0
	local root = vim.fs.root(buf, { ".git", "Makefile", "package.json", ".nvim" })
	if root then
		return root
	end
	-- Fallback: walk upward for an existing .nvim/commands.json
	local start = vim.api.nvim_buf_get_name(0)
	start = (start ~= "" and vim.fn.fnamemodify(start, ":p:h")) or vim.loop.cwd()
	local found = vim.fs.find(".nvim/commands.json", { upward = true, path = start })[1]
	if found then
		return vim.fn.fnamemodify(found, ":h:h") -- go up from /.nvim/commands.json to project root
	end
	return vim.loop.cwd()
end

local function ensure_dir(path)
	local stat = vim.uv.fs_stat(path)
	if not stat then
		vim.fn.mkdir(path, "p")
	end
end

local function json_read(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local ok, data = pcall(vim.json.decode, f:read("*a"))
	f:close()
	if ok then
		return data
	end
	return nil
end

local function json_write(path, tbl)
	local f = assert(io.open(path, "w"))
	f:write(vim.json.encode(tbl or {}))
	f:write("\n")
	f:close()
end

local function system_lines(cmd, cwd)
	local ok, res = pcall(function()
		if vim.system then
			local out = vim.system(cmd, { text = true, cwd = cwd }):wait()
			return vim.split(out.stdout or "", "\n", { trimempty = true })
		else
			local saved = vim.loop.cwd()
			if cwd then
				vim.loop.chdir(cwd)
			end
			local lines = vim.fn.systemlist(table.concat(cmd, " "))
			if cwd then
				vim.loop.chdir(saved)
			end
			return lines
		end
	end)
	return ok and res or {}
end

-- -------- storage (custom commands) --------
local function store_path()
	local root = project_root()
	local base = root .. "/.nvim"
	ensure_dir(base)
	return base .. "/commands.json"
end

local function load_custom()
	local data = json_read(store_path()) or {}
	return data
end

local function save_custom(data)
	json_write(store_path(), data)
end

-- -------- discover Make targets --------
local function discover_make()
	local root = project_root()
	if not vim.uv.fs_stat(root .. "/Makefile") then
		return {}
	end
	-- Portable-ish target scrape: use `make -qp` and collect targets that look like plain names.
	local lines = system_lines({ "make", "-qp" }, root)
	local targets = {}
	for _, l in ipairs(lines) do
		-- match: target: deps
		local name = l:match("^([A-Za-z0-9%._-]+):")
		if name and not name:match("^%.PHONY$") and not name:match("^%$") then
			targets[name] = true
		end
	end
	local out = {}
	for t, _ in pairs(targets) do
		table.insert(out, {
			name = t,
			cmd = "make " .. t,
			source = "make",
		})
	end
	table.sort(out, function(a, b)
		return a.name < b.name
	end)
	return out
end

-- -------- discover package.json scripts --------
local function discover_npm()
	local root = project_root()
	local pj = json_read(root .. "/package.json")
	if not pj or type(pj.scripts) ~= "table" then
		return {}
	end
	local out = {}
	for k, _ in pairs(pj.scripts) do
		table.insert(out, {
			name = k,
			cmd = "npm run " .. k .. " --silent",
			source = "npm",
		})
	end
	table.sort(out, function(a, b)
		return a.name < b.name
	end)
	return out
end

-- -------- combine sources --------
local function list_commands()
	local root = project_root()
	local custom = load_custom()
	local items = {}

	for name, entry in pairs(custom) do
		table.insert(items, {
			name = name,
			cmd = entry.cmd,
			source = "custom",
			cwd = entry.cwd or root,
		})
	end

	for _, it in ipairs(discover_make()) do
		table.insert(items, it)
	end
	for _, it in ipairs(discover_npm()) do
		table.insert(items, it)
	end

	table.sort(items, function(a, b)
		if a.source == b.source then
			return a.name < b.name
		end
		-- custom first, then make, then npm
		local rank = { custom = 1, make = 2, npm = 3 }
		return (rank[a.source] or 99) < (rank[b.source] or 99)
	end)
	return items
end

-- -------- runner --------
M.opts = {
	open = function(title)
		-- 15-line terminal split
		vim.cmd("botright 15split")
		vim.cmd("enew")
		vim.bo.bufhidden = "wipe"
		vim.bo.buftype = "terminal"
		vim.bo.swapfile = false
		vim.api.nvim_buf_set_name(0, "term://" .. title)
		return 0
	end,
}

local last_run = nil

local function run_cmd(rec)
	local title = string.format("%s:%s", rec.source or "cmd", rec.name or "?")
	local bufnr = M.opts.open(title)
	local term_start = function()
		vim.fn.termopen(rec.cmd, { cwd = rec.cwd or project_root() })
		vim.cmd("startinsert")
	end
	if bufnr and bufnr ~= 0 then
		vim.api.nvim_set_current_buf(bufnr)
		term_start()
	else
		term_start()
	end
	last_run = rec
end

-- -------- public API --------
function M.pick()
	local pick = require("mini.pick")
	local items = list_commands()
	local display = function(item)
		local left = string.format("[%s] %s", item.source, item.name)
		local right = item.cmd
		return left .. " — " .. right
	end
	pick.start({
		source = {
			name = "Project Commands",
			items = items,
			choose = function(item)
				run_cmd(item)
			end,
			show = display,
		},
	})
end

function M.run_by_name(name)
	for _, it in ipairs(list_commands()) do
		if it.name == name then
			return run_cmd(it)
		end
	end
	vim.notify(("No command named '%s'"):format(name), vim.log.levels.WARN)
end

function M.rerun_last()
	if last_run then
		run_cmd(last_run)
	else
		vim.notify("No last command.", vim.log.levels.WARN)
	end
end

-- :Run <name> <shell command ...>
function M.define(name, cmd)
	local root = project_root()
	local data = load_custom()
	data[name] = { cmd = cmd, cwd = root }
	save_custom(data)
	vim.notify(("Saved command '%s'"):format(name))
end

function M.edit_store()
	vim.cmd("edit " .. store_path())
end

function M.list_echo()
	local items = list_commands()
	for _, it in ipairs(items) do
		vim.api.nvim_echo({ { string.format("[%s] %-20s  %s", it.source, it.name, it.cmd) } }, false, {})
	end
end

-- -------- commands --------
function M.setup(opts)
	M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

	vim.api.nvim_create_user_command("CmdPick", function()
		M.pick()
	end, {})
	vim.api.nvim_create_user_command("Cmd", function(opts)
		M.run_by_name(opts.args)
	end, {
		nargs = 1,
		complete = function()
			return vim.tbl_map(function(i)
				return i.name
			end, list_commands())
		end,
	})
	vim.api.nvim_create_user_command("CmdLast", function()
		M.rerun_last()
	end, {})
	vim.api.nvim_create_user_command("CmdEdit", function()
		M.edit_store()
	end, {})
	vim.api.nvim_create_user_command("CmdList", function()
		M.list_echo()
	end, {})

	vim.api.nvim_create_user_command("Run", function(opts)
		-- opts.args is the raw string, quotes preserved
		local name, cmd = opts.args:match("^(%S+)%s+(.+)$")
		if not name or not cmd then
			vim.notify(
				'Usage: :Run <name> <shell command...>\nExample: :Run stubs "python3 sync_stubs.py"',
				vim.log.levels.ERROR
			)
			return
		end
		M.define(name, cmd)
	end, { nargs = "+", complete = "shellcmd" })
end

return M
