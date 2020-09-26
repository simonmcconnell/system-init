function Install-Scoop {
    Set-ExecutionPolicy RemoteSigned -scope CurrentUser
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

function Install-PowerShellModule {
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $ModuleName,

        [ScriptBlock]
        [Parameter(Mandatory = $true)]
        $PostInstall = {}
    )

    if (!(Get-Command -Name $ModuleName -ErrorAction SilentlyContinue)) {
        Write-Host "Installing $ModuleName"
        Install-Module -Name $ModuleName -Scope CurrentUser -Confirm $true
        Import-Module $ModuleName -Confirm

        Invoke-Command -ScriptBlock $PostInstall
    } else {
        Write-Host "$ModuleName was already installed, skipping"
    }
}

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

Install-Scoop

scoop bucket add extras

scoop install 7zip
scoop install pwsh
scoop install git
scoop install vscode
scoop install vcredist2019
scoop install windows-terminal
scoop install elixir
scoop install curl
scoop install calibre
scoop install slack
scoop install autohotkey
scoop install megasync
scoop install picpick
scoop install vcxsrv
scoop install filezilla-server
scoop install posh-git
scoop install oh-my-posh

# Install-PowerShellModule 'PSReadLine' { }
