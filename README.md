# My dotfiles

To reproduce my environment easily.
Was tested on Ubuntu-24.04 under WSL2.

[Nvim](https://github.com/neovim/neovim/blob/master/INSTALL.md) and [Tmux](https://github.com/kiyoon/tmux-appimage) can be installed with an appimage, you don't need a compiler or specific libraries.

# Details on AppImages

## Neovim

What I do to install Neovim :
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage

# To execute the AppImage
./nvim.appimage
```
Try to execute it and if it doesn't work because you don't have FUSE installed you can try the following :

```bash
./nvim.appimage --appimage-extract
```

You can now use `/home/user/squashfs-root/usr/bin/nvim`. Consider using an alias.

## Tmux

Use this line from the repo linked above:

```bash
# It will install on ~/.local/bin/tmux
source <(curl -sS https://raw.githubusercontent.com/kiyoon/tmux-local-install/master/install.sh)
```

Don't forget to add `~/.local/bin` to your PATH. You can do it by adding this line to your `.bashrc` :

```bash
export PATH='$HOME/.local/bin:$PATH'
```
