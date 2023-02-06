# My NeoVim Configurations

## Python provider and dependencies

Following configurations assume that all Python dependencies are installed into
a virtualenv called `nvim`, e.g.:

```sh
pyenv virtualenv 3.11 nvim
pyenv shell nvim
```

To install or upgrade Python dependencies:

```sh
pip install -U -r requirements.txt
```

## Usage

1. Clone this repo to replace your `~/.config/nvim/` folder:
    ```shell
    mv ~/.config/nvim/ ~/.config/nvim.backup
    git clone https://github.com/genzj/mynvimrc.git
    ```
1. Create the init file `~/.config/nvim/init.vim` with following content:
    ```vimscript
    exe 'luafile '.stdpath('config').'/mynvimrc.lua'
    ```

## Add language supports

To add per-host config for languages, edit the `~/.config/nvim/init.vim` to set
`g:mynvim_install` to extend the
[`mynvim.configs.install`](https://github.com/genzj/mynvim/blob/main/lua/mynvim/configs/install.lua)
table.

E.g.:

```vimscript
lua <<EOF
vim.g.mynvim_install = {
    treesitter = {
        "fish",
        "rust",
    },

    mason = {
        "rust-analyzer",
    },

    servers = {
        ["rust-analyzer"] = {},
    }
}
EOF
luafile ~/.config/nvim/mynvimrc.lua
```

Ref:

- [LSP servers](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
- [Treesitter parsers](https://github.com/nvim-treesitter/nvim-treesitter#supported-languages)

