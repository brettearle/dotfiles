return {
	{
		"neovim/nvim-lspconfig",
		ft = { "vue", "typescript", "typescriptreact", "javascript", "javascriptreact" },
		config = function()
			local lspconfig = require("lspconfig")

			-- Explicit position encoding avoids Neovim 0.10+ quirks/warnings
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.general = capabilities.general or {}
			capabilities.general.positionEncodings = { "utf-16" }

			local vue_language_server_path = vim.fn.stdpath("data")
				.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

			local vue_plugin = {
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
				configNamespace = "typescript",
			}

			lspconfig.volar.setup({
				filetypes = { "vue" },
				capabilities = capabilities,
			})

			lspconfig.vtsls.setup({
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
				capabilities = capabilities,
				settings = {
					vtsls = {
						tsserver = {
							globalPlugins = { vue_plugin },
						},
					},
				},
			})

			-- Volar-first gd, installed when any LSP attaches (so it definitely exists)
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					if vim.bo[bufnr].filetype ~= "vue" then
						return
					end

					local function volar_definition()
						local volar
						for _, c in ipairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
							if c.name == "volar" or c.name == "vue_ls" then
								volar = c
								break
							end
						end
						if not volar then
							vim.notify("Volar not attached", vim.log.levels.WARN)
							return
						end

						local enc = volar.offset_encoding or "utf-16"
						local params = vim.lsp.util.make_position_params(0, enc)

						vim.lsp.buf_request(bufnr, "textDocument/definition", params, function(err, result)
							if err then
								vim.notify("definition error: " .. err.message, vim.log.levels.ERROR)
								return
							end
							if not result or vim.tbl_isempty(result) then
								vim.notify("No definition returned here", vim.log.levels.INFO)
								return
							end

							local loc = result[1] or result
							vim.lsp.util.jump_to_location(loc, enc)
						end)
					end

					vim.keymap.set("n", "gd", volar_definition, { buffer = bufnr, desc = "Go to definition (Volar)" })
				end,
			})
		end,
	},
}
