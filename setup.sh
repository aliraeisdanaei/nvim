#!/bin/bash

# ============================================================================
# Neovim Setup Script
# Automatically installs dependencies and plugins for the nvim config
# Supports Ubuntu/Debian and Manjaro/Arch Linux
# ============================================================================

set -e  # Exit on error

echo "=========================================="
echo "Neovim Configuration Setup"
echo "=========================================="
echo ""

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Error: Cannot detect OS"
    exit 1
fi

echo "Detected OS: $OS"
echo ""

# ============================================================================
# Ubuntu/Debian Setup
# ============================================================================
if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    echo "Setting up for Ubuntu/Debian..."
    echo ""
    
    # Update package manager
    echo "Updating package manager..."
    sudo apt-get update
    sudo apt-get upgrade -y
    echo ""
    
    # Install system dependencies
    echo "Installing system dependencies..."
    sudo apt-get install -y \
        neovim \
        git \
        curl \
        build-essential \
        clang \
        clangd \
        python3 \
        python3-pip \
        python3-dev \
        ripgrep \
        universal-ctags
        # nodejs \
        # npm
    echo ""
    
    # Install Python LSP Server
    echo "Installing Python Language Server..."
    pip3 install python-lsp-server
    pip3 install python-lsp-server[all]  # Install all optional plugins
    echo ""

# ============================================================================
# Manjaro/Arch Setup
# ============================================================================
elif [[ "$OS" == "arch" || "$OS" == "manjaro" ]]; then
    echo "Setting up for Manjaro/Arch..."
    echo ""
    
    # Update package manager
    echo "Updating package manager..."
    sudo pacman -Syu --noconfirm
    echo ""
    
    # Install system dependencies
    echo "Installing system dependencies..."
    sudo pacman -S --noconfirm \
        neovim \
        git \
        curl \
        base-devel \
        clang \
        python \
        python-pip \
        ripgrep \
        universal-ctags
        # nodejs \
        # npm
    echo ""
    
    # Install Python LSP Server
    echo "Installing Python Language Server..."
    sudo pacman -S python-lsp-server
    sudo pacman -S python-lsp-server[all]  # Install all optional plugins
    echo ""

else
    echo "Error: Unsupported OS ($OS)"
    echo "This script supports Ubuntu, Debian, Arch, and Manjaro"
    exit 1
fi

# ============================================================================
# Install vim-plug (if not already installed)
# ============================================================================
echo "Setting up vim-plug..."
VIM_PLUG_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload"
mkdir -p "$VIM_PLUG_DIR"

if [ ! -f "$VIM_PLUG_DIR/plug.vim" ]; then
    echo "Installing vim-plug..."
    curl -fLo "$VIM_PLUG_DIR/plug.vim" \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "vim-plug installed successfully!"
else
    echo "vim-plug already installed"
fi
echo ""

# ============================================================================
# Install Neovim plugins
# ============================================================================
echo "Installing Neovim plugins..."
echo "This may take a moment..."
echo ""

# Create nvim config directory if it doesn't exist
mkdir -p ~/.config/nvim

# Install plugins using vim-plug
nvim --headless "+PlugInstall" "+qall" 2>/dev/null || true

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Your Neovim configuration is ready!"
echo ""
echo "To verify everything is working:"
echo "  - Open a C/C++ file and press Ctrl+Space for autocompletion"
echo "  - Open a Python file and press Ctrl+Space for autocompletion"
echo "  - Press <space>ff to find files"
echo "  - Press <space>tree to toggle the file tree"
echo ""
echo "Launch Neovim with: nvim"
echo ""
