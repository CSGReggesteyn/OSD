### Install OSDCloud module if not present
if (Get-InstalledModule -Name OSD -ErrorAction SilentlyContinue) {
    Write-Host " OSDCloud Module already installed"
    #Import-Module OSD < slows down the script
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
    Write-Host " 1.) Windows installatie starten"
    Write-Host " 2.) Installeer/Update OSDCloud (Alleen in Windows)"
    Write-Host " Q.) Sluit Powershell"
    Write-Host
    Write-Host " Selecteer een optie en druk op Enter: "  -nonewline
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
