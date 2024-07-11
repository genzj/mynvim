# My NeoVim Configurations

## Prerequisites

1. Install the [mise CLI](https://mise.jdx.dev/getting-started.html#_1-install-mise-cli)
1. Add Python 3.11 to mise by running `mise use --global python@3.11`
1. Create a virtualenv for NVIM Python providers: `mise exec python@3.11 -- python -m venv ~/.venvs/nvim`


## Usage

1. Clone this repo to replace your `~/.config/nvim/` folder:
    ```shell
    mv ~/.config/nvim/ ~/.config/nvim.backup
    git clone https://github.com/genzj/mynvim.git ~/.config/nvim
    ```
1. Install Python dependencies:
    ```sh
    cd ~/.config/nvim/
    which pip  # make sure the output shows a path to virtualenv, e.g. ~/.venvs/nvim/bin/pip
    [[ $(which pip) == "$HOME/.venvs/nvim/bin/pip" ]] && pip install -U -r requirements.txt
    ```
1. Create the init file `~/.config/nvim/init.vim` with following content:
    ```vimscript
    lua require("mynvim")
    ```
1. (Windows) Install LLVM by following [this
   wiki](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support#llvm-clang)
   then setting it in the beginning of the `init.vim`, e.g.:
   ```vimscript
    lua <<EOF
    vim.env.PATH = vim.env.PATH .. ";D:\\code\\LLVM\\bin"
    vim.g.mynvim_install = {
        treesitter = {
            "rust",
        },

        servers = {
            ["rust_analyzer"] = {},
        }
    }
    EOF
   ```
1. (Optional) if this repo is cloned to a different folder, the path should be
   added to `runtimepath`, e.g.:
   ```vimscript
    set runtimepath+=e:/proj/mynvim
    lua require("mynvim")
   ```
1. Install
    [ripgrep](https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation)
    for enhanced grep and substitution experience.
1. Run `nvim` and Lazy should install all plugins automatically.
1. After Lazy finishes its work, quit and reopen NVIM to make sure all plugins are loaded.

## Customization

### Add language supports

To add per-host config for languages, edit the `~/.config/nvim/init.vim` to set
`g:mynvim_install` to extend the
[`mynvim.configs.install`](https://github.com/genzj/mynvim/blob/main/lua/mynvim/configs/install.lua)
table. Run vim command `:ShowInstallConfig` to inspect the final config.

E.g.:

```vimscript
lua <<EOF
vim.g.mynvim_install = {
    -- optional presets, read "mynvim.configs.install" variable "blends" for
    -- details
    blends = {
        "rust",
        "python",
    },
    treesitter = {
        "fish",
        "rust",
    },

    -- Install non-lsp extentions, such as null-ls dependencies.
    -- For lsp-config supported servers, check the `servers` key below.
    -- Package list: https://mason-registry.dev/registry/list
    mason = {
    },

    nls = {
        -- "nls." or "null_ls." (recommended) prefixed items will be loaded
        -- from the null-ls package
        -- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
        "null_ls.builtins.formatting.stylua",

        -- "package.subpackage:a.b.c" is equivalent to
        -- require("package.subpackage").a.b.c

        -- the ":" can be ommitted if the default object is desired, i.e.
        -- "package.subpackage" is equivalent to "package.subpackage:" and
        -- require("package.subpackage")
    },

    -- LSP server configs. Configured servers will be installed by mason-lspconfig
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
    servers = {
        ["rust_analyzer"] = {},
    }
}
EOF

lua require("mynvimrc.lua")
```

Ref:

- [LSP servers](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
- [Treesitter parsers](https://github.com/nvim-treesitter/nvim-treesitter#supported-languages)

### Override Options

Some options are set in the `VeryLazy` user event callbacks so directly change
them from `init.vim` may not work as expected. A more reliable solution is
registering `autocmd`s for the same event and override options there, e.g.

```vimscript
augroup CustomOptionSetup
    au!
    au User VeryLazy let &guifont="Hack_Nerd_Font:h13.000000,".&guifont
augroup END

lua require("mynvim")
```

