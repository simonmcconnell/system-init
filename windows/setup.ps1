function Install-Scoop {
    scoop --version 
    if ($LastExitCode -ne 0)
    {
        Set-ExecutionPolicy RemoteSigned -scope CurrentUser
        Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    }
}

function Install-VSCode {
    $installerFile = "vscode-install.exe"
    $installerPath = (Join-Path $env:TEMP $installerFile)
    $url = "https://vscode-update.azurewebsites.net/latest/win32-x64/stable"

    Write-Verbose "Downloading vscode..."
    iwr -useb $url -OutFile $installerPath
    
    # Install with the context menu, file association, and add to path options (and don't run code after install:
    Write-Verbose "Installing vscode to $installerPath..."
    $args = "/SILENT /MERGETASKS=`"addcontextmenufiles,addcontextmenufolders,addtopath,associatewithfiles,!desktopicon,!runcode`""
    Start-Process $installerPath -ArgumentList $args -Wait
    
    Remove-Item $installerPath -Force
}

# scoop
Install-Scoop
scoop bucket add extras

# powershell
scoop install pwsh posh-git oh-my-posh

# utils
scoop install 7zip coreutils curl less sudo grep

# devtools
scoop install git vcredist2019 windows-terminal vcxsrv openssh # vscode
Install-VSCode

# languages
# erlang install fails with 'ERROR Exit code was -1073741515!' if vcredist2013 is not installed, which includes MSVCR120.dll
scoop install vcredist2013 erlang@23.1 elixir python nodejs-lts nim

# apps
scoop install calibre megasync slack picpick filezilla-server autohotkey exercism nimbletext beyondcompare

# wsl
sudo Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
# hyper-v
sudo Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

Write-Host -ForegroundColor Red "!!! RESTART REQUIRED AFTER ENABLING WSL & HYPER-V !!!"

# download config files
curl https://raw.githubusercontent.com/simonmcconnell/system-init/master/common/.gitconfig --output $HOME\.gitconfig
curl https://raw.githubusercontent.com/simonmcconnell/system-init/master/windows/settings.json --output "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"

# set 7zip file associations
Write-Host -ForegroundColor Blue ">>> 7zip <<<"
Write-Host -ForegroundColor Blue "run 7zFM.exe as administrator and:"
Write-Host -ForegroundColor Blue "- set file associations in Tools > Options"
Write-Host -ForegroundColor Blue "- on 7-Zip tab, check 'Integrate 7-Zip to shell context menu' and deselect unwanted context menu items"
Write-Host -ForegroundColor Blue "- on Editor tab, set all to vscode (likely C:\Users\simon\AppData\Local\Programs\Microsoft VS Code\Code.exe)"

sudo $HOME\scoop\apps\7zip\current\7zFM.exe

# configure git for windows
git config --global core.autocrlf true
git config --global credential.helper manager

# $exts = '7z','zip','rar','001','xz','txz','lzma','tar','cpio','bz2','bzip2','tbz2','tbz','gz','gzip','tgz','tpz','z','taz','lzh','lhz','rpm','dep','arj','wim','swm','fat','ntfs','dmg','hfs','xar','squashfs'
# ForEach ($ext in $etxs) {
#    sudo cmd /c "assoc .$ext=7-Zip.$ext"
#    sudo cmd /c ftype 7-Zip.$ext=$HOME\scoop\apps\7-Zip\current\7zFM.exe
#}
