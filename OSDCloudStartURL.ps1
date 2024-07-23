### Set the repository and ISO download link
$RepositoryURL  = 'https://raw.githubusercontent.com/CSGReggesteyn/OSD/main'
$ISOURL         = 'https://osdcloudreg.blob.core.windows.net/osdcloudiso/OSDCloud_NoPrompt.iso'

### Install OSDCloud module if not present
#if (Get-InstalledModule -Name OSD) { < Get-InstalledModule can be slow so replaced with Test-Path, need to test in WinPE
if (Test-Path -Path "$env:ProgramFiles\WindowsPowerShell\Modules\OSD") {
    Write-Host " OSDCloud Module already installed"
} else {
    Clear-Host
    Write-Host " ***************************"
    Write-Host " *      OSDCloud Menu      *"
    Write-Host " ***************************"
    Write-Host
    Write-Host " Installing OSDCloud Module"
    Write-Host
    Install-Module OSD -force
}

$MainMenu = {
    Write-Host " ***************************"
    Write-Host " *      OSDCloud Menu      *"
    Write-Host " ***************************"
    Write-Host
    Write-Host " 1.) OSDCloud Local (WinPE)"
    Write-Host " 2.) Install/Update OSDCloudUSB (Windows)"
    Write-Host " Q.) Exit Powershell"
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
            Invoke-WebPSScript $RepositoryURL/OSDCloudStartAndUpdate.ps1
        }
        2 {
            Invoke-WebPSScript $RepositoryURL/OSDCloudUpdateMenu.ps1
        }
        Q {
            Exit
        }
    }
}
While ($Select -ne "Z")
