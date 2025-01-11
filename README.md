# My dotfiles

To reproduce my environment easily.
Was tested on Ubuntu-24.04 under WSL2.
This is an attempt to reproduce my own environment on a machine on which I don't have root access.

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

# Details on Neovim

I use treesitter which needs to be compiled using make. You may not have a compiler on your machine thus precompiled libraries could help you.x
I provide you the link to [this repo](https://github.com/anasrar/nvim-treesitter-parser-bin/) which contains all of them zipped in a single file. Follow those two steps to make treesitter functional :

First get the ZIP file
```bash
wget https://github.com/anasrar/nvim-treesitter-parser-bin/releases/download/linux/all.zip
```
You can then extract a specific parser or all of them. On the 11th of January of 2025, all the parsers make a total of 214M.

It is possible that you don't have `unzip` installed, luckily you can do it easily with Python. Just run the following script :

```python
import zipfile
from pathlib import Path

# Path to the .zip file
zip_path = "all.zip"

# Target directory to extract .so files.
# Adapt to you own config folder. Here my is mynvim
output_dir = Path.home() / ".local/share/mynvim/lazy/nvim-treesitter/parser"
output_dir.mkdir(parents=True, exist_ok=True)

# Open the .zip file
with zipfile.ZipFile(zip_path, 'r') as zip_ref:
    # Iterate through all files in the archive
    for file in zip_ref.namelist():
        # Check if the file is a .so file
        if file.endswith("so"):
            print(f"Extracting: {file}")
            zip_ref.extract(file, path=output_dir)

print(f"Extraction complete. Files are in {output_dir}")
```

Enjoy !
