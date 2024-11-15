# vimfiles
Setting files for vim on Windows

## Prerequisites

- vim 9.1 or later
- Windows 11 or Ubuntu 22.04
- Powershell 7.4.5+, Msys2 or WSL2 for Windows 11

## Cloning this repo

For PowerShell:

```powershell
git clone --recurse-submodules git@github.com:pathtrk/vimfiles.git $HOME\vimfiles  
```

For Msys2, or bash on Ubuntu (including WSL2):

```bash
git clone --recurse-submodules git@github.com:pathtrk/vimfiles.git $HOME/.vim
```

## Applying the saved settings for Windows Terminal

Place `windows_setup/terminal/settings.json` into your settings directory of Wndows Teminal app.

Otherwise you can copy the file contents and paste into your `settings.json` that can be opened from Windows Terminal's settings menu, then save yours.

## Installing plugins via Vundle

Launch vim and run the following from the editor: 

```
PluginInstall
```

This downloads plugins specified in `vimrc` and makes them ready.

## Install vim for Msys2

```bash
pacman -Syu
pacman -S vim
```

You might not need the first line of these commands.

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

