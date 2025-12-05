-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
    on_attach = function()
      local root_dir = require('lspconfig.util').root_pattern 'package.json'
      local active_clients = vim.lsp.get_active_clients()
      if root_dir then
        for _, client in pairs(active_clients) do
          -- stop tsserver if denols is already active
          if client.name == 'denols' then
            client.stop()
          end
          if client.name == 'svelte-language-server' then
            client.stop()
          end
        end
      end
    end,
  },
  { 'github/copilot.vim' },
  {
    'tanvirtin/vgit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
    -- Lazy loading on 'VimEnter' event is necessary.
    event = 'VimEnter',
    config = function()
      require('vgit').setup {
        keymaps = {
          ['n <C-k>'] = function()
            require('vgit').hunk_up()
          end,
          {
            mode = 'n',
            key = '<C-j>',
            handler = 'hunk_down',
            desc = 'Go down in the direction of the hunk',
          },
          ['n <leader>gs'] = function()
            require('vgit').buffer_hunk_stage()
          end,
          ['n <leader>gr'] = function()
            require('vgit').buffer_hunk_reset()
          end,
          ['n <leader>gp'] = function()
            require('vgit').buffer_hunk_preview()
          end,
          ['n <leader>gb'] = 'buffer_blame_preview',
          ['n <leader>gf'] = function()
            require('vgit').buffer_diff_preview()
          end,
          ['n <leader>gh'] = function()
            require('vgit').buffer_history_preview()
          end,
          ['n <leader>gu'] = function()
            require('vgit').buffer_reset()
          end,
          ['n <leader>gd'] = function()
            require('vgit').project_diff_preview()
          end,
          ['n <leader>gx'] = function()
            require('vgit').toggle_diff_preference()
          end,
        },
        live_blame = {
          enabled = false,
          delay = 1000,
          virtual_text = true,
          virtual_text_position = 'eol',
          virtual_text_priority = 100,
        },
      }
    end,
  },
  { 'ThePrimeagen/vim-be-good' },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      direction = 'vertical',
    },
  },
}
