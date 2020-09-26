function Install-Scoop {
    Set-ExecutionPolicy RemoteSigned -scope CurrentUser
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

function Install-FromScoop {
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $PackageName
    )

    scoop install $PackageName
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

Install-FromScoop 'pwsh'
Install-FromScoop 'git'
Install-FromScoop '7zip'
Install-FromScoop 'vscode'
Install-FromScoop 'windows-terminal'
Install-FromScoop 'erlang'
Install-FromScoop 'elixir'
Install-FromScoop 'curl'
Install-FromScoop 'calibre'
Install-FromScoop 'slack'
Install-FromScoop 'autohotkey'
Install-FromScoop 'megasync'
Install-FromScoop 'picpick'
Install-FromScoop 'vcxsrv'
Install-FromScoop 'filezilla-server'
Install-FromScoop 'posh-git'
Install-FromScoop 'oh-my-posh'

Install-PowerShellModule 'PSReadLine' { }
