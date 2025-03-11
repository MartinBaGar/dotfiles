return {
	{
		'chipsenkbeil/distant.nvim',
		enabled = false,
		remote = false,
		branch = 'v0.3',
		config = function()
			require('distant'):setup({
				manager = {
					user = true
				}
			})
		end
	}
}
