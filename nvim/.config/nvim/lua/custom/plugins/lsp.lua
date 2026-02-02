return {
	{
		"neovim/nvim-lspconfig",
		ft = { "vue", "typescript", "typescriptreact", "javascript", "javascriptreact" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")

			-- Path to @vue/language-server installed by Mason
			local vue_language_server_path = vim.fn.stdpath("data")
				.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

			local vue_plugin = {
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
				configNamespace = "typescript",
			}

			-- 1) Vue server: use ONLY ONE name to avoid double config.
			lspconfig.volar.setup({
				filetypes = { "vue" },
			})

			-- 2) TS server: vtsls + Vue TS plugin bridge
			lspconfig.vtsls.setup({
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
				settings = {
					vtsls = {
						tsserver = {
							globalPlugins = { vue_plugin },
						},
					},
				},
			})

			-- 3) Attach immediately for the current buffer (important with Lazy ft-loading)
			local bufnr = vim.api.nvim_get_current_buf()
			lspconfig.vtsls.manager.try_add_wrapper(bufnr)
			lspconfig.volar.manager.try_add_wrapper(bufnr)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "vue",
				callback = function()
					vim.keymap.set("n", "gd", function()
						local clients = vim.lsp.get_active_clients({ bufnr = 0 })
						local volar = nil
						for _, c in ipairs(clients) do
							if c.name == "volar" or c.name == "vue_ls" then
								volar = c
								break
							end
						end

						if volar then
							vim.lsp.buf.definition({ id = volar.id })
						else
							vim.lsp.buf.definition()
						end
					end, { buffer = true, desc = "Go to definition (Volar)" })
				end,
			})
		end,
	},
}
