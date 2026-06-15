local M = {}

M.options = {}

function M.setup(options)
	-- Overwrite the options in the default config with the given ones
	M.options = vim.tbl_deep_extend("force", {}, M.defaults(), options)
end

function M.defaults()
	local defaults = {
		hide_following_blank_lines = true,
		hide_current_comment = true,
		enable_notifications = true,
		using_folke_lazyvim_setup = false,
		apply_to_new_buffer = false,
		apply_on_buffer_change = false,
		foldtext = function(folded_count)
			return "(" .. folded_count .. " comments)"
		end,
	}
	return defaults
end

return M
