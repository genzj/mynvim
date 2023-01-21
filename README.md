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


```vimscript
exe 'luafile '.stdpath('config').'/mynvimrc.lua'
```

