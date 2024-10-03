# vimfiles
Setting files for vim on Windows 11

## Prerequisites

Install [vim-plug](https://github.com/junegunn/vim-plug) to handle plugins.

```powershell
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/vimfiles/autoload/plug.vim -Force
```

## Install

```powershell
git clone git@github.com:pathtrk/vimfiles.git $HOME/vimfiles  
```

And install all the plugins via `:PlugInstall`.
