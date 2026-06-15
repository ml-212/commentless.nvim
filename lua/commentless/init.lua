local config = require("commentless.config")
local internal = require("commentless.internal")

local M = {}

function M.setup(options)
	config.setup(options)
	internal.setup()

	local sub_cmds = {
		["toggle"] = M.toggle,
		["hide"] = M.hide,
		["reveal"] = M.reveal,
		["is_hidden"] = M.is_hidden_cmd,
	}

	vim.api.nvim_create_user_command("Commentless", function(cmd)
		local sub_cmd = cmd.args == "" and "toggle" or cmd.args
		local ok = pcall(sub_cmds[sub_cmd])
		if not ok then
			vim.notify("[commentless.commands]: Unknown command", vim.log.levels.ERROR)
		end
	end, {
		desc = "Fold/Unfold all comments",
		nargs = "*",
		complete = function()
			local keys = {}
			for key in pairs(sub_cmds) do
				table.insert(keys, key)
			end
			return keys
		end,
	})

	-- Apply hide comments to either new or switched buffers
	local autocmdHooks = {}

	if config.options.apply_to_new_buffer then
		table.insert(autocmdHooks, "BufReadPost")
		table.insert(autocmdHooks, "BufNewFile")
	end

	if config.options.apply_on_buffer_change then
		-- overwriting since it'll be called on new Buffers as well.
		autocmdHooks = { "BufEnter" }
	end

	local onAutocmd = function()
		vim.schedule(function()
			if internal.is_hidden() then
				internal.hide()
			else
				internal.reveal()
			end
		end)
	end

	if next(autocmdHooks) ~= nil then
		vim.api.nvim_create_autocmd(autocmdHooks, {
			callback = function()
				onAutocmd()
			end,
		})
	end
end

function M.toggle()
	internal.toggle()
end

function M.hide()
	internal.hide()
end

function M.reveal()
	internal.reveal()
end

function M.is_hidden()
	return internal.is_hidden()
end

function M.is_hidden_cmd()
	vim.notify("Comments are " .. (M.is_hidden() and "hidden" or "revealed"))
end

return M
