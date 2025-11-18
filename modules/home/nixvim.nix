{ inputs, ... }:
{
  flake-file.inputs.nixvim.url = "github:nix-community/nixvim";
  flake-file.inputs.nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";

  den.aspects.nixvim.homeManager =
    { pkgs, ... }:

    {
      imports = [ inputs.nixvim.homeModules.nixvim ];
      programs.nixvim = {
        enable = true;

        colorschemes.gruvbox.enable = true;
        defaultEditor = true;
        editorconfig.enable = true;
        globals.mapleader = " ";
        nixpkgs.pkgs = pkgs;
        vimAlias = true;

        opts = {
          number = true;
          shiftwidth = 2;
          undofile = true;
        };

        plugins = {
          airline.enable = true;
          auto-save.enable = true;
          avante.enable = true;
          bufferline.enable = true;
          clangd-extensions.enable = true;
          copilot-vim.enable = true;
          gitblame.enable = true;
          gitgutter.enable = true;
          indent-o-matic.enable = true;
          lsp-format.enable = true;
          lsp-status.enable = true;
          neo-tree.enable = true;
          noice.enable = true;
          telescope.enable = true;
          treesitter.enable = true;
          web-devicons.enable = true;
          which-key.enable = true;

          lsp = {
            enable = true;

            servers = {
              clangd.enable = true;
              gopls.enable = true;
              nixd.enable = true;
              pylsp.enable = true;
              tilt_ls.enable = true;

              metals = {
                enable = true;
                filetypes = [
                  "sc"
                  "scala"
                  "java"
                ];
              };

              protols = {
                enable = true;
                package = null;
              };

              regols = {
                enable = true;
                filetypes = [ "rego" ];
              };
            };
          };

          cmp = {
            enable = true;

            autoEnableSources = true;

            settings.sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
            ];
          };
        };

        extraPlugins = with pkgs.vimPlugins; [
          nvim-metals
        ];

        extraConfigLua = ''
          local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "scala", "sbt" },
            callback = function()
              require("metals").initialize_or_attach({})
            end,
            group = nvim_metals_group,
          })
          require("telescope")
        '';
      };

      programs.fish.shellAbbrs.vim = "nvim";
    };
}
