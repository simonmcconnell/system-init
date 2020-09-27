function Install-Scoop {
    scoop --version 
    if ($LastExitCode -ne 0)
    {
        Set-ExecutionPolicy RemoteSigned -scope CurrentUser
        Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    }
}

# scoop
Install-Scoop
scoop bucket add extras

# powershell
scoop install pwsh posh-git oh-my-posh

# utils
scoop install 7zip coreutils curl less sudo 

# devtools
scoop install git vcredist2019 windows-terminal vcxsrv openssh # vscode

# add vscode to context menus
# $HOME\scoop\apps\current\vscode-install-context.reg

# languages
# erlang install fails with 'ERROR Exit code was -1073741515!' if vcredist2013 is not installed, which includes MSVCR120.dll
scoop install vcredist2013 erlang@23.1 elixir python nodejs-lts

# apps
scoop install calibre megasync slack picpick filezilla-server autohotkey exercism

# refreshenv

# wsl
sudo Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

# download config files
curl https://raw.githubusercontent.com/simonmcconnell/system-init/master/windows/.gitconfig --output $HOME\.gitconfig
curl https://raw.githubusercontent.com/simonmcconnell/system-init/master/windows/settings.json --output "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
