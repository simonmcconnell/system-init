#! /bin/bash

log() {
    echo $1 >> ~/env-setup.log
}

install_docker() {
    echo -e '\e[0;33mSetting up docker\e[0m'

    sudo apt update
    sudo apt install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common \
        -y

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository --yes \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable nightly test"

    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo /etc/init.d/docker start
}

install_git() {
    echo -e '\e[0;33mInstalling git\e[0m'

    sudo add-apt-repository ppa:git-core/ppa --yes
    sudo apt update
    sudo apt install git -y
}

install_devtools() {
    echo -e '\e[0;33mInstalling dev software/runtimes/sdks\e[0m'

    ## asdf
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
    echo ". $HOME/.asdf/asdf.sh" >> ~/.bashrc

    ## erlang
    sudo apt -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk
    export KERL_BUILD_DOCS=yes

    asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
    asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
    asdf plugin-add nodejs git@github.com:asdf-vm/asdf-nodejs.git
    asdf plugin-add dotnet-core https://github.com/emersonsoares/asdf-dotnet-core.git
    asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
    asdf plugin-add python
    
    # Import the Node.js release team's OpenPGP keys to main keyring:
    bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
}

install_jetbrainsmono() {
  sudo apt install fontconfig
  curl -L https://download.jetbrains.com/fonts/JetBrainsMono-2.001.zip --output $1/jetbrainsmono.zip
  unzip $1/jetbrainsmono.zip -d $1/jetbrainsmono
  sudo mkdir -p /usr/share/fonts/truetype/jetbrainsmono && sudo cp $1/jetbrainsmono/ttf/*.ttf "$_"
  sudo fc-cache -f -v
}

install_exercism () {
    read -p "Install exercism? (Y/n)" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        wget https://github.com/exercism/cli/releases/download/v3.0.13/exercism-linux-64bit.tgz
        tar -xf exercism-linux-64bit.tgz -C $1/exercism
        mkdir -p ~/bin
        mv $1/exercism/exercism ~/bin
        read -p "Enter exercism token from http://exercism.io/my/settings: " token
        exercism configure --token=$token
        exercism configure --workspace ~/code/github/exercism
        git clone https://github.com/simonmcconnell/exercism ~/code/github/exercism
    fi
}

echo -e '\e[0;33mPreparing to setup a linux machine from a base install\e[0m'

tmpDir=/tmp/setup-base

if [ ! -d "$tmpDir" ]; then
    mkdir -p $tmpDir
fi

## General updates
sudo apt update
sudo apt upgrade -y

## Utilities
sudo apt install unzip curl jq -y

# Create folder for code from github
mkdir -p ~/code/github

install_git
wget https://raw.githubusercontent.com/simonmcconnell/system-init/master/wsl/setup-shell.sh
source "./setup-shell.sh"
install_devtools
install_docker
install_jetbrainsmono $tmpDir
install_exercism $tmpDir

echo -e '\e[0;33mInstall erlang/elixir/nodejs/dotnet-core/go with `asdf install <lang> <version>`\e[0m'
echo -e '\e[0;33m  Elixir: specify the OTP version: `asdf install elixir 1.10.4-otp-23`\e[0m'
echo -e '\e[0;33m  Python: set the global versions w/`asdf global python 3.8.6 2.7.13`\e[0m'
echo -e '\e[0;33m    then the `python`, `python3` and `python2` commands will use these versions\e[0m'

rm -rf $tmpDir
