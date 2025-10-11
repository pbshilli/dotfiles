NEOVIM_VERSION='0.9.0'
NEOVIM_URL="https://github.com/neovim/neovim/releases/download/v$NEOVIM_VERSION/nvim.appimage"

# Download Neovim AppImage
mkdir -p ~/Applications
pushd ~/Applications
curl -LO $NEOVIM_URL
chmod u+x nvim.appimage
popd

# Install to CLI
mkdir -p ~/.local/bin
ln -s ~/Applications/nvim.appimage ~/.local/bin/nvim

# Download/install Neovim packages
# NOTE: pbshilli-dotfiles/start will autoload on Neovim start
#       pbshilli-dotfiles/opt will only load with :packadd
mkdir -p ~/.local/share/nvim/site/pack/pbshilli-dotfiles/start
pushd ~/.local/share/nvim/site/pack/pbshilli-dotfiles/start

# Fuzzy file search
git clone https://github.com/kien/ctrlp.vim.git

# Color scheme
git clone https://github.com/romainl/Apprentice.git

# File explorer
git clone https://github.com/tpope/vim-vinegar.git
git clone https://github.com/tpope/vim-dispatch.git

# CTAGS utility
git clone https://github.com/ludovicchabant/vim-gutentags.git

# Syntax highlighting
git clone https://github.com/kergoth/vim-bitbake.git

# Secure modelines
git clone https://github.com/ciaranm/securemodelines.git

popd

# Set up the Python language server
sudo apt install python3-pylsp

