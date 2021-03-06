#!/bin/bash
log() {
    echo $1 >> ~/env-setup.log
}

install_shell() {
    echo -e '\e[0;33mSetting up zsh as the shell\e[0m'

    ## zsh
    sudo apt-get install zsh -y

    curl -L http://install.ohmyz.sh | sh
    {
        CMD="$( sudo chsh -s /usr/bin/zsh ${USER} )"
    } || {
        log "Failed to set zsh as default shell: $CMD"
    }
    ZSH_CUSTOM=~/.oh-my-zsh/custom
    git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

    ## tmux
    {
        CMD="$( sudo apt install tmux urlview -y )"
    } || {
        log "Failed to install tmux & urlview: $CMD"
    }
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    ## install GitHub CLI
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
    sudo apt-add-repository https://cli.github.com/packages
    sudo apt update
    sudo apt install gh -y
}

install_dotfiles() {
    echo -e '\e[0;33mSetting up standard dotfiles\e[0m'

    git clone https://github.com/simonmcconnell/system-init ~/code/github/system-init

    WSL_SCRIPTS_DIR=~/code/github/system-init/wsl   #"$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"

    ln -s $WSL_SCRIPTS_DIR/.zshrc ~/.zshrc
    mkdir -p ~/.tmux
    ln -s $WSL_SCRIPTS_DIR/.tmux.conf ~/.tmux/.tmux.conf
    # ln -s $WSL_SCRIPTS_DIR/.vimrc ~/.vimrc
    ln -s $WSL_SCRIPTS_DIR/.urlview ~/.urlview
    ln -s $WSL_SCRIPTS_DIR/../common/.gitconfig ~/.gitconfig
    git config --global core.autocrlf false
    mkdir -p ~/.config/gh
    ln -s $WSL_SCRIPTS_DIR/../common/gh-config.yml ~/.config/gh/config.yml
    ln -s $WSL_SCRIPTS_DIR/.default-python-packages ~/.default-python-packages

    ## Only setup cred manager if it's wsl
    if [[ "$WSLENV" ]]
    then
        git config --global credential.helper '/mnt/c/Program\\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe'
    else 
        git config --global credential.helper manager
    fi

    tmux source ~/.tmux/.tmux.conf
}

# zsh colorize plugin requires pygments or chroma
pip install Pygments

install_dotfiles
install_shell

mv ~/.zshrc ~/.zshrc.oh-my-zsh
mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc

