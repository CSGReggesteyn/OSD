### Install OSDCloud module if not present
if (Get-InstalledModule -Name OSD -ErrorAction SilentlyContinue) {
    Import-Module OSD
} else {
    Write-Host " ***************************"
    Write-Host " *         OSDCloud        *"
    Write-Host " ***************************"
    Write-Host
    Write-Host " Installing OSDCloud Module"
    Write-Host
    Install-Module OSD -force
}

$MainMenu = {
    Write-Host " ***************************"
    Write-Host " *         OSDCloud        *"
    Write-Host " ***************************"
    Write-Host
    Write-Host " 1.) OSDCloud Local (WinPE)"
    Write-Host " 2.) Install/Update OSDCloudUSB (Windows)"
    Write-Host " Q.) Exit Menu"
    Write-Host
    Write-Host " Select an option and press Enter: "  -nonewline
}
Clear-Host
Do {
    Clear-Host
    Invoke-Command $MainMenu
    $Select = Read-Host
    Switch ($Select)
        {
        1 {
            Start-OSDCloudGUI
        }
        2 {
            Invoke-WebPSScript 'https://raw.githubusercontent.com/CSGReggesteyn/OSD/main/OSDCloudUpdateMenu.ps1'
        }
        Q {
            Exit
        }
    }
}
While ($Select -ne "Z")
