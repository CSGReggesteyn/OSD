Clear-Host
Write-Host " ***************************"
Write-Host " *    WinPE Installation   *"
Write-Host " ***************************"
Write-Host

### Test if any USB drive is fount
$testdisk = GET-WMIOBJECT win32_diskdrive | Where { $_.mediatype -eq 'Removable Media' -or $_.mediatype -eq 'Removable Media' -or $_.InterfaceType -eq 'USB' }
#Option 2: $testdisk2 = Get-Disk | Where-Object -FilterScript {$_.Bustype -Eq "USB"}
if ( $testdisk -eq $null) {
    Write-Host "No USB Drive found, going back to menu"
    Write-Host
    cmd /c 'pause'
    Invoke-WebPSScript 'https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/OSDCloudUpdateMenu.ps1'   
} else {
    Write-Host " Downloading WinPE"
    Write-Host
    
    ### Starting WinPE install from Azure Blob and writing the necessary files
    New-OSDCloudUSB -fromIsoUrl 'https://jvdosd.blob.core.windows.net/bootimage/OSDCloud_NoPrompt.iso'
    
    ### Search OSDCloud disk after installation
    $disk = Get-WMIObject Win32_Volume | Where-Object { $_.Label -eq 'OSDCloudUSB' }
    $disk = $disk.Name
    
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
    
    ### Creating files on de OSDCloud drive
    New-Item -ItemType Directory -Path $location\Automate -force -ErrorAction SilentlyContinue | Out-Null
    Invoke-WebRequest -Uri https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/Update/Automate/Start-OSDCloudGUI.json -OutFile $location\Automate\Start-OSDCloudGUI.json
    Invoke-WebRequest -Uri https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/Update/Start-Menu.ps1 -OutFile $disk\Start-Menu.ps1
    New-Item -Path "$location" -Name "$file" -ItemType "file" -Value $version -force -ErrorAction SilentlyContinue | Out-Null
    New-Item -Path "$location" -Name "$fileWinPE" -ItemType "file" -Value $versionWinPE -force -ErrorAction SilentlyContinue | Out-Null

    $MainMenu = {
        Write-Host " ***************************"
        Write-Host " *    WinPE Installation   *"
        Write-Host " ***************************"
        Write-Host
        Write-Host " WinPE Installation complete"
        Write-Host " Install one more WinPE to a USB drive?"
        Write-Host
        Write-Host " 1.) Yes (insert new USB drive before continuing)"
        Write-Host " 2.) No (delete downloaded ISO)"
        Write-Host " Q.) Back (keeps ISO in Download folder)"
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
                Invoke-WebPSScript 'https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/OSDCloudInstallWinPE.ps1'
            }
            2 {
                ### Getting the active download folder, Dismounting the image (if mounted) and removing the ISO file
                $ISOPath = (New-Object -ComObject Shell.Application).Namespace('shell:Downloads').Self.Path
                Dismount-DiskImage -ImagePath "$ISOPath\OSDCloud_NoPrompt.iso" -ErrorAction SilentlyContinue | Out-Null
                Remove-Item $ISOPath\OSDCloud_NoPrompt.iso -ErrorAction SilentlyContinue | Out-Null
                Invoke-WebPSScript 'https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/OSDCloudUpdateMenu.ps1'
            }
            Q {
                Invoke-WebPSScript 'https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/OSDCloudUpdateMenu.ps1'
            }
        }       
    }
    While ($Select -ne "Z")
}