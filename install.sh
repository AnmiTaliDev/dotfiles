#!/bin/bash

# =============================================================================
# Dotfiles Installation Script
# =============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# =============================================================================
# Helper Functions
# =============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# =============================================================================
# Dependency Checking
# =============================================================================

check_system() {
    log_info "Checking system requirements..."
    
    if [[ ! -f /etc/arch-release ]]; then
        log_error "This script is designed for Arch Linux only"
        exit 1
    fi
    
    if ! command_exists pacman; then
        log_error "pacman not found. Are you running Arch Linux?"
        exit 1
    fi
    
    log_success "System check passed"
}

check_zsh() {
    log_info "Checking Zsh installation..."
    
    if ! command_exists zsh; then
        log_warning "Zsh not found. Installing..."
        sudo pacman -S --needed zsh
    fi
    
    log_success "Zsh is available"
}

check_oh_my_zsh() {
    log_info "Checking Oh My Zsh installation..."
    
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_warning "Oh My Zsh not found. Installing..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    log_success "Oh My Zsh is available"
}

check_zsh_plugins() {
    log_info "Checking Zsh plugins..."
    
    local plugins_dir="$HOME/.oh-my-zsh/custom/plugins"
    
    # Check zsh-syntax-highlighting
    if [[ ! -d "$plugins_dir/zsh-syntax-highlighting" ]]; then
        log_warning "zsh-syntax-highlighting not found. Installing..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting"
    fi
    
    # Check zsh-autosuggestions
    if [[ ! -d "$plugins_dir/zsh-autosuggestions" ]]; then
        log_warning "zsh-autosuggestions not found. Installing..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$plugins_dir/zsh-autosuggestions"
    fi
    
    log_success "Zsh plugins are available"
}

check_submodules() {
    log_info "Checking git submodules..."
    
    if [[ ! -f .gitmodules ]]; then
        log_error ".gitmodules not found. This repo should have submodules."
        exit 1
    fi
    
    # Initialize and update submodules
    log_info "Initializing git submodules..."
    git submodule update --init --recursive
    
    log_success "Git submodules initialized"
}

check_dependencies() {
    log_info "Checking package dependencies..."
    
    local packages=(
        "ripgrep"
        "fzf"
        "htop"
        "micro"
        "git"
    )
    
    local missing_packages=()
    
    for package in "${packages[@]}"; do
        if ! pacman -Q "$package" >/dev/null 2>&1; then
            missing_packages+=("$package")
        fi
    done
    
    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        log_warning "Missing packages: ${missing_packages[*]}"
        log_info "Installing missing packages..."
        sudo pacman -S --needed "${missing_packages[@]}"
    fi
    
    log_success "All package dependencies are satisfied"
}

check_rust_dependencies() {
    log_info "Checking Rust dependencies..."
    
    if ! command_exists cargo; then
        log_warning "Rust/Cargo not found. Installing..."
        sudo pacman -S --needed rust
    fi
    
    log_success "Rust dependencies are satisfied"
}

build_and_install_meow() {
    log_info "Building and installing meow..."
    
    local meow_dir="$PWD/thirdparty/meow"
    
    if [[ ! -d "$meow_dir" ]]; then
        log_error "thirdparty/meow directory not found"
        log_info "Make sure you cloned the repo with submodules:"
        log_info "git clone --recurse-submodules https://github.com/AnmiTaliDev/dotfiles"
        exit 1
    fi
    
    if [[ ! -f "$meow_dir/Cargo.toml" ]]; then
        log_error "Cargo.toml not found in thirdparty/meow"
        exit 1
    fi
    
    # Build meow
    log_info "Building meow from source..."
    cd "$meow_dir"
    cargo build --release
    
    # Install meow
    log_info "Installing meow binary..."
    sudo install -m 755 target/release/meow /usr/local/bin/meow
    
    cd - > /dev/null
    
    # Verify installation
    if command_exists meow; then
        log_success "meow installed successfully"
    else
        log_error "meow installation failed"
        exit 1
    fi
}

# =============================================================================
# Installation Functions
# =============================================================================

update_system() {
    log_info "Updating system packages..."
    sudo pacman -Syu --noconfirm
    log_success "System updated"
}

install_zshrc() {
    log_info "Installing .zshrc configuration..."
    
    local source_file="$PWD/.zshrc"
    local target_file="$HOME/.zshrc"
    
    if [[ ! -f "$source_file" ]]; then
        log_error ".zshrc not found in current directory"
        exit 1
    fi
    
    # Backup existing .zshrc
    if [[ -f "$target_file" ]]; then
        local backup_file="$target_file.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backing up existing .zshrc to $backup_file"
        cp "$target_file" "$backup_file"
    fi
    
    # Install new .zshrc
    install -m 644 "$source_file" "$target_file"
    
    log_success ".zshrc installed to $target_file"
}

# =============================================================================
# Main Installation Process
# =============================================================================

main() {
    log_info "Starting dotfiles installation..."
    echo
    
    # System checks
    check_system
    
    # Update system
    update_system
    
    # Check and install dependencies
    check_zsh
    check_oh_my_zsh
    check_zsh_plugins
    check_dependencies
    check_rust_dependencies
    check_submodules
    build_and_install_meow
    
    # Install configurations
    install_zshrc
    
    echo
    log_success "Installation completed successfully!"
    echo
    log_info "To start using the new configuration:"
    log_info "  1. Restart your terminal, or"
    log_info "  2. Run: source ~/.zshrc"
    log_info "  3. Consider changing your default shell: chsh -s /bin/zsh"
}

# =============================================================================
# Script Entry Point
# =============================================================================

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
