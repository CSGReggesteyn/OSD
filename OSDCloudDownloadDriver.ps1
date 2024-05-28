$MainMenu = {
    Write-Host " ***************************"
    Write-Host " *     OSDCloud Drivers    *"
    Write-Host " ***************************"
    Write-Host
    Write-Host " 1.) Download HP Drivers"
    Write-Host " 2.) Download DELL Drivers"
    Write-Host " 3.) Download Lenovo Drivers"
    Write-Host " 4.) Download Microsoft Drivers"
    Write-Host " Q.) Terug"
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
            Update-OSDCloudUSB -DriverPack HP
            Invoke-WebPSScript 'https://raw.githubusercontent.com/CSGReggesteyn/OSD/main/OSDCloudDownloadDriver.ps1'
        }
        2 {
            Update-OSDCloudUSB -DriverPack Dell
            Invoke-WebPSScript 'https://raw.githubusercontent.com/CSGReggesteyn/OSD/main/OSDCloudDownloadDriver.ps1'
        }
        3 {
            Update-OSDCloudUSB -DriverPack Lenovo
            Invoke-WebPSScript 'https://raw.githubusercontent.com/CSGReggesteyn/OSD/main/OSDCloudDownloadDriver.ps1'
        }
        4 {
            Update-OSDCloudUSB -DriverPack Microsoft
            Invoke-WebPSScript 'https://raw.githubusercontent.com/CSGReggesteyn/OSD/main/OSDCloudDownloadDriver.ps1'
        }
        Q {
            Invoke-WebPSScript 'https://raw.githubusercontent.com/CSGReggesteyn/OSD/main/OSDCloudUpdateMenu.ps1'
        }
    }
}
While ($Select -ne "Z")
