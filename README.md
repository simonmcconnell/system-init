# system-init
mostly stolen from [aaronpowell's repo](https://github.com/aaronpowell/system-init)

## Windows

- enable wsl `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`
- enable hyper-v `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All`
- install office
- install [ScanSnap Home](http://scansnap.fujitsu.com/global/dl/win-ix500.html)
- install ubuntu (WSL)
- install [Jetbrains Mono](https://www.jetbrains.com/lp/mono/) Fonts
- run install script:
  `iwr 'https://raw.githubusercontent.com/simonmcconnell/system-init/master/windows/setup.ps1' | iex`

## WSL (Ubuntu)

1. run install script
   `curl https://raw.githubusercontent.com/simonmcconnell/system-init/master/wsl/setup.sh | bash`

2. install languages with [asdf](https://asdf-vm.com/)
    
    asdf plugin list
    
    asdf list all elixir
    
    asdf install erlang 23.1
    asdf install elixir 1.10.4-otp-23
    asdf install nodejs
    asdf install dotnet-core
    asdf install python
    asdf install golang
    
    asdf global erlang 23.1
    asdf global elixir 1.10.4
    asdf global python 3.8.5 2.7.18
    
