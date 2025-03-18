return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()
		local set = vim.keymap.set

		-- Add or skip cursor above/below the main cursor.
		set({ "n", "v" }, "<up>", function() mc.lineAddCursor(-1) end, { desc = "Add a cursor above the current one" })
		set({ "n", "v" }, "<down>", function() mc.lineAddCursor(1) end, { desc = "Add a cursor below the current one" })
		set({ "n", "v" }, "<leader><up>", function() mc.lineSkipCursor(-1) end,
			{ desc = "Skip one line above and add a cursor" })
		set({ "n", "v" }, "<leader><down>", function() mc.lineSkipCursor(1) end,
			{ desc = "Skip one line below and add a cursor" })

		-- Add or skip adding a new cursor by matching word/selection
		set({ "n", "v" }, "<leader>n", function() mc.matchAddCursor(1) end,
			{ desc = "Add a cursor at the next occurrence of the word" })
		set({ "n", "v" }, "<leader>s", function() mc.matchSkipCursor(1) end,
			{ desc = "Skip the next occurrence and add a cursor" })
		set({ "n", "v" }, "<leader>N", function() mc.matchAddCursor(-1) end,
			{ desc = "Add a cursor at the previous occurrence of the word" })
		set({ "n", "v" }, "<leader>S", function() mc.matchSkipCursor(-1) end,
			{ desc = "Skip the previous occurrence and add a cursor" })

		-- Add all matches in the document
		set({ "n", "v" }, "<leader>A", mc.matchAllAddCursors, { desc = "Add a cursor at all occurrences of the word" })

		-- Rotate between cursors
		set({ "n", "v" }, "<left>", mc.nextCursor, { desc = "Move to the next cursor" })
		set({ "n", "v" }, "<right>", mc.prevCursor, { desc = "Move to the previous cursor" })

		-- Delete the main cursor
		set({ "n", "v" }, "<leader>x", mc.deleteCursor, { desc = "Remove the current cursor" })

		-- Add and remove cursors with control + left click
		set("n", "<c-leftmouse>", mc.handleMouse, { desc = "Add/remove a cursor with Ctrl + left-click" })

		-- Toggle cursor at the main cursor position
		set({ "n", "v" }, "<c-q>", mc.toggleCursor, { desc = "Toggle a cursor at the current position" })

		-- Clone every cursor and disable the originals
		set({ "n", "v" }, "<leader><c-q>", mc.duplicateCursors, { desc = "Duplicate all cursors and disable originals" })

		-- Manage cursor states
		set("n", "<esc>", function()
			if not mc.cursorsEnabled() then
				mc.enableCursors()
			elseif mc.hasCursors() then
				mc.clearCursors()
			end
		end, { desc = "Toggle multicursor mode or clear all cursors" })

		-- Restore last used cursors if they were cleared
		set("n", "<leader>gv", mc.restoreCursors, { desc = "Restore last used cursors" })

		-- Align cursor columns
		set("n", "<leader>a", mc.alignCursors, { desc = "Align all cursors into columns" })

		-- Split visual selections by regex
		set("v", "S", mc.splitCursors, { desc = "Split selection into multiple cursors using regex" })

		-- Append/insert for each line of visual selections
		set("v", "I", mc.insertVisual, { desc = "Insert text at the beginning of each selection" })
		set("v", "A", mc.appendVisual, { desc = "Append text at the end of each selection" })

		-- Match new cursors within visual selections using regex
		set("v", "M", mc.matchCursors, { desc = "Match cursors within selection using regex" })

		-- Rotate visual selection contents
		set("v", "<leader>t", function() mc.transposeCursors(1) end, { desc = "Transpose cursor selections forward" })
		set("v", "<leader>T", function() mc.transposeCursors(-1) end, { desc = "Transpose cursor selections backward" })

		-- Jumplist support
		set({ "v", "n" }, "<c-i>", mc.jumpForward, { desc = "Jump forward in cursor history" })
		set({ "v", "n" }, "<c-o>", mc.jumpBackward, { desc = "Jump backward in cursor history" })

		-- Customize cursor highlights
		local hl = vim.api.nvim_set_hl
		hl(0, "MultiCursorCursor", { link = "Cursor" })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn" })
		hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end
}
