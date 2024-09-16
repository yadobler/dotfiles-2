local lspconfig = require("lspconfig")
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
		map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
		map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
		map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		-- The following autocommand is used to enable inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
local on_attach_global = function(client, bufnr)
	require("lsp_signature").on_attach({
		bind = true, -- This is mandatory, otherwise border config won't get registered.
		handler_opts = {
			border = "rounded",
		},
	}, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end
require("mason-lspconfig").setup_handlers({
	function(server_name)
		lspconfig[server_name].setup({
			on_attach = on_attach_global,
			capabilities = capabilities,
			cmd = {
				vim.fn.stdpath("data") .. "/mason/bin/" .. server_name:gsub("_", "%-"),
			},
		})
	end,
	["nil_ls"] = function()
		lspconfig.nil_ls.setup({
			on_attach = on_attach_global,
			capabilities = capabilities,
			cmd = { vim.fn.stdpath("data") .. "/mason/bin/nil" },
		})
	end,
	["wgsl_analyzer"] = function()
		lspconfig.wgsl_analyzer.setup({
			on_attach = on_attach_global,
			capabilities = capabilities,
			cmd = {
				vim.fn.stdpath("data") .. "/mason/bin/wgsl_analyzer.cmd",
			},
		})
	end,

	["jdtls"] = function() end,

	["rust_analyzer"] = function() end,

	["fennel_language_server"] = function()
		lspconfig.fennel_language_server.setup({
			on_attach = on_attach_global,
			capabilities = capabilities,
			cmd_env = { VIRTUAL_ENV = vim.fn.expand("~/.qtile_venv/") },
			filetypes = { "fennel" },
			single_file_support = true,
			settings = {
				fennel = {
					workspace = {
						-- If you are using hotpot.nvim or aniseed,
						-- make the server aware of neovim runtime files.
						library = vim.api.nvim_list_runtime_paths(),
					},
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})
	end,

	["pylsp"] = function()
		lspconfig.pylsp.setup({
			on_attach = on_attach_global,
			capabilities = capabilities,
			-- cmd_env = {VIRTUAL_ENV = vim.fn.expand("~/.qtile_venv/")};
			settings = {
				pylsp = {
					plugins = {
						pycodestyle = {
							ignore = { "W391", "E302", "E501", "E305", "E126", "W291", "E123", "E251" },
						},
					},
				},
			},
		})
	end,
	["lua_ls"] = function()
		lspconfig.lua_ls.setup({
			on_attach = on_attach_global,
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
					workspace = {
						checkThirdParty = false,
					},
				},
			},
		})
	end,
})
