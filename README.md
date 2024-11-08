# vimfiles
Setting files for vim on Windows

## Prerequisites

- vim 9.1 or later
- Windows 11 (might work with Windows 10, but not tested)
- Powershell 7.4.5 or later

## Cloning this repo

On Windows 11:

```powershell
git clone --recurse-submodules git@github.com:pathtrk/vimfiles.git $HOME\vimfiles  
```

On Wsl or Linux:

```bash
git clone --recurse-submodules git@github.com:pathtrk/vimfiles.git $HOME/.vim
```

## Installing plugins via Vundle

Launch vim and run the following from the editor: 

```
PluginInstall
```

This downloads plugins specified in `vimrc` and makes them ready.

## Build vim from source

Ubuntu does not have the latest version of vim. To build vim from source, follow the steps below:

```bash
sudo apt update && sudo apt install -y git make clang libtool-bin
sudo apt install -y libpython3-dev

mkdir -p ~/.local/src

git clone https://github.com/vim/vim.git ~/.local/src/vim
cd ~/.local/src/vim/src
```

Then edit `src/Makefile` and uncomment the following line:

```makefile
CONF_OPT_GUI = --disable-gui   #L321
CONF_OPT_PYTHON3 = --enable-python3interp  # L453
CONF_OPT_CSCOPE = --enable-cscope    # L465 
```

Lastly, run the following:

```bash
make 
sudo make install
```

