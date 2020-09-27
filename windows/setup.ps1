# function CreateRefresenv {
#     Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://github.com/chocolatey/choco/raw/stable/src/chocolatey.resources/helpers/functions/Update-SessionEnvironment.ps1')
# }

function Install-Scoop {
    scoop --version 
    if ($LastExitCode -ne 0)
    {
        Set-ExecutionPolicy RemoteSigned -scope CurrentUser
        Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    }
}

function Install-Fonts {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FontFile
    )
    try {
        $font = $fontFile | split-path -Leaf
        If (!(Test-Path "c:\windows\fonts\$($font)")) {
            switch (($font -split "\.")[-1]) {
                "TTF" {
                    $fn = "$(($font -split "\.")[0]) (TrueType)"
                    break
                }
                "OTF" {
                    $fn = "$(($font -split "\.")[0]) (OpenType)"
                    break
                }
            }
            Copy-Item -Path $fontFile -Destination "C:\Windows\Fonts\$font" -Force
            New-ItemProperty -Name $fn -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $font
        }
    }
    catch {
        write-warning $_.exception.message
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
scoop install git vscode vcredist2019 windows-terminal vcxsrv openssh

# languages
# erlang install is failing with 'ERROR Exit code was -1073741515!' if vcredist2013 is not installed, which includes MSVCR120.dll
scoop install vcredist2013 erlang@23.1 elixir python nodejs-lts

# apps
scoop install calibre megasync slack picpick filezilla-server autohotkey

# refreshenv

# wsl
sudo Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
