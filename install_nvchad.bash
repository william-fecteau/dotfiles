#!/bin/bash

# Neovim
wget https://github.com/neovim/neovim/releases/download/v0.11.7/nvim-linux-x86_64.tar.gz
tar xzvf nvim-linux-x86_64.tar.gz
sudo mv nvim-linux-x86_64 /opt/nvim
sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim

# Tree sitter
cargo install --locked tree-sitter-cli

# Nvchad
mkdir -p ~/.config/nvim
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
