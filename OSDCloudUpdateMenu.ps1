### Search OSDCloud and WinPE disk
$disk = Get-WMIObject Win32_Volume | Where-Object { $_.Label -eq 'OSDCloudUSB' }
$disk = $disk.Name
$diskwinpe = Get-WMIObject Win32_Volume | Where-Object { $_.Label -eq 'WinPE' }
$diskwinpe = $diskwinpe.Name

### Getting version from .\Update\Version.txt and .\Update\VersionWinPE.txt
$version = Invoke-WebRequest -Uri https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/Update/Version.txt
$version = $version.Content.Split([Environment]::NewLine) | Select -First 1
$versionWinPE = Invoke-WebRequest -Uri https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/Update/VersionWinPE.txt
$versionWinPE = $versionWinPE.Content.Split([Environment]::NewLine) | Select -First 1

### Getting OSDCloudUSB and WinPE version from drive
$file = "Version.txt"
$fileWinPE = "VersionWinPE.txt"
$folder = 'OSDCloud\'
$location = "$disk$folder"
$versionondisk = Get-Content "$location$file" -ErrorAction SilentlyContinue
$versionWinPEondisk = Get-Content "$location$fileWinPE" -ErrorAction SilentlyContinue

Clear-Host
$MainMenu = {
    Write-Host " ***************************"
    Write-Host " *         OSDCloud        *"
    Write-Host " ***************************"
    Write-Host
    
    ### Check if OSDCloudUSB drive is found
    if ($disk -eq $null) {
        ### Menu if disk is not found
        Write-host " OSDCloudUSB drive not found" -ForegroundColor Red
        Write-host " Check that the partition name matches: OSDCloudUSB" -ForegroundColor Red
        Write-Host
        Write-Host " 1.) Install OSDCloudUSB (WinPE)" -nonewline
        Write-Host " $versionWinPE" -ForegroundColor green
        Write-Host " Q.) Back"
        Write-Host
        Write-Host " Select an option and press Enter: "  -nonewline
    } else {
        Write-Host " OSDCloudUSB " -nonewline
        ### Check if OSDCloudUSB version is lower then new version
        if ($versionondisk -lt $version) {
            Write-Host "$versionondisk " -nonewline -ForegroundColor Red
            Write-Host "found on $disk"
        } else {
            Write-Host "$versionondisk " -nonewline -ForegroundColor green
            Write-Host "found on $disk"
        }
        Write-Host " WinPE " -nonewline
        ### Check if WinPE version is lower then new version
        if ($versionWinPEondisk -lt $versionWinPE) {
            Write-Host "$versionWinPEondisk " -nonewline -ForegroundColor Red
            Write-Host "found on $diskwinpe"
        } else {
            Write-Host "$versionWinPEondisk " -nonewline -ForegroundColor green
            Write-Host "found on $diskwinpe"
        }
        ### Menu if disk is found
        Write-Host
        Write-Host " 1.) Install OSDCloudUSB (WinPE)" -nonewline
        Write-Host " $versionWinPE" -ForegroundColor green
        Write-Host " 2.) Update OSDCloudUSB config file" -nonewline
        Write-Host " $version" -ForegroundColor green
        Write-Host " 3.) Download Windows"
        Write-Host " 4.) Download Drivers"
        Write-Host " Q.) Back"
        Write-Host
        Write-Host " Select an option and press Enter: "  -nonewline
    }
}
Clear-Host
Do {
    Clear-Host
    Invoke-Command $MainMenu
    $Select = Read-Host
    Switch ($Select) {
        1 {
            Invoke-WebPSScript 'https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/OSDCloudInstallWinPE.ps1'
        }
        2 {
            Invoke-WebPSScript 'https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/OSDCloudUSBUpdate.ps1'
        }
        3 {
            Invoke-WebPSScript 'https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/OSDCloudDownloadWindows.ps1'
        }
        4 {
            Invoke-WebPSScript 'https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/OSDCloudDownloadDriver.ps1'
        }
        Q {
            Invoke-WebPSScript 'https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/OSDCloudStartURL.ps1'
        }
        R {
            Invoke-WebPSScript 'https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/OSDCloudUpdateMenu.ps1'
        }
    }
}
While ($Select -ne "Z")
