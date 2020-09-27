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

    echo -e '\e[0;33myou can install erlang/elixir/nodejs/dotnet-core/go with `asdf install <lang> <version>`\e[0m'
    echo -e '\e[0;33mspecify the OTP version with elixir: `asdf install elixir 1.10.4-otp-23`\e[0m'
    echo -e '\e[0;33mset the global pythong versions with `asdf global python 3.8.6 2.7.13`\e[0m'
    echo -e '\e[0;33mthen the `python`, `python3` and `python2` commands will use these versions\e[0m'
    
    # wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
    # sudo dpkg -i erlang-solutions_2.0_all.deb
    # sudo apt update
    # sudo apt install esl-erlang
    # sudo apt install elixir

    ## dotnet
    # read -p "Install .NET Core? (Y/n)" -n 1 -r
    # echo
    # if [[ $REPLY =~ ^[Yy]$ ]]
    # then
    #     wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
    #     sudo dpkg -i packages-microsoft-prod.deb
    #     sudo add-apt-repository universe --yes
    #     sudo apt update
    #     sudo apt install dotnet-sdk-2.2 dotnet-sdk-3.1 -y
    
    #     read -p "Install .NET Preview SDK? (Y/n)" -n 1 -r
    #     echo
    #     if [[ $REPLY =~ ^[Yy]$ ]]
    #     then
    #         sudo docker pull mcr.microsoft.com/dotnet/core/5.0.100-preview
    #     fi
    # fi

    ## go
    # read -p "Install Golang 1.15.2? (Y/n)" -n 1 -r
    # echo
    # if [[ $REPLY =~ ^[Yy]$ ]]
    # then
    #     gover=1.15.2
    #     wget "https://storage.googleapis.com/golang/go$gover.linux-amd64.tar.gz" --output-document "$tmpDir/go.tar.gz"
    #     sudo tar -C /usr/local -xzf "$tmpDir/go.tar.gz"
    # fi

    ## Node.js via fnm
    # curl https://raw.githubusercontent.com/Schniz/fnm/master/.ci/install.sh | bash
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
        sudo snap install exercism
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

# Create standard github clone location
mkdir -p ~/code/github

install_git
source "./setup-shell.sh"
install_devtools
install_docker
install_jetbrainsmono $tmpDir
install_exercism

rm -rf $tmpDir
