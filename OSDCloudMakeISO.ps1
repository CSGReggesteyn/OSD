### ADK and ADK Add-on Download URL and preferd Workspace location
$ADKURL             = 'https://go.microsoft.com/fwlink/?linkid=2271337'
$ADKAddonURL        = 'https://go.microsoft.com/fwlink/?linkid=2271338'
$NewOSDWorkspace    = "C:\OSDCloud"

Clear-host
Write-Host " ***************************"
Write-Host " *   OSDCloud ISO Maker    *"
Write-Host " ***************************"
Write-Host

### Install Windows ADK
if (-Not (get-package | where Name -Like "Windows Assessment and Deployment Kit")) {
    Write-host " Installing Windows ADK"
    Invoke-WebRequest $ADKURL -outfile $DownloadsPath\adksetup.exe
    Start-Process -NoNewWindow -FilePath "$DownloadsPath\adksetup.exe" -ArgumentList "/quiet /features OptionId.DeploymentTools /norestart" -wait
    Remove-Item -Path $DownloadsPath\adksetup.exe -Force -ErrorAction SilentlyContinue
} else {
    Write-host " Windows ADK already installed"
}

### Install Windows ADK add-on
if (-Not (get-package | where Name -Like "Windows Assessment and Deployment Kit Windows Preinstallation Environment Add-ons")) {
        Write-host " Installing Windows ADK add-on"
    Invoke-WebRequest $ADKAddonURL -outfile $DownloadsPath\adkwinpesetup.exe
    Start-Process -NoNewWindow -FilePath "$DownloadsPath\adkwinpesetup.exe" -ArgumentList "/quiet /norestart" -wait
    Remove-Item -Path $DownloadsPath\adkwinpesetup.exe -Force -ErrorAction SilentlyContinue

} else {
    Write-host " Windows ADK add-on already installed"
}

### Creating OSDCloud Workspace
if (-Not (Get-OSDCloudWorkspace)) {
    Write-host " Making new OSDCloud Template/Workspace"
    New-OSDCloudTemplate
    New-OSDCloudWorkspace "$NewOSDWorkspace"
    $WorkspaceLoc = Get-OSDCloudWorkspace
    Write-host " Workspace created, location: $WorkspaceLoc"
} else {
    $WorkspaceLoc = Get-OSDCloudWorkspace
    Write-host " OSDCloud Workspace already set up, location: $WorkspaceLoc "
}

### Cleanup WinPE folders
$KeepTheseDirs = @('boot','efi','en-us','nl-nl','sources','fonts','resources')
Get-ChildItem $WorkspaceLoc\Media | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
Get-ChildItem $WorkspaceLoc\Media\Boot | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
Get-ChildItem $WorkspaceLoc\Media\EFI\Microsoft\Boot | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

### Configure WinPE
Edit-OSDCloudWinPE -CloudDriver * -StartURL $RepositoryURL/OSDCloudStartURL.ps1
Copy-Item "$NewOSDWorkspace\OSDCloud_NoPrompt.iso" -Destination "$DownloadsPath" -ErrorAction SilentlyContinue
Write-host " OSDCloud ISO created and copied to $DownloadsPath"

$MainMenu = {
    Write-Host " ***************************"
    Write-Host " *   OSDCloud ISO Maker    *"
    Write-Host " ***************************"
    Write-Host
    Write-Host " 1.) Cleanup Workspace, downloaded files and software"
    Write-Host " Q.) Back (Keeps OSDCloud Workspace and installed software)"
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
            Clear-host
            Write-Host " ***************************"
            Write-Host " *   OSDCloud ISO Maker    *"
            Write-Host " ***************************"
            Write-Host
            Write-Host " Removing Files from $WorkspaceLoc"
            Remove-Item -Path $WorkspaceLoc -Force -Recurse -ErrorAction SilentlyContinue
            Write-Host
            Write-Host " Uninstalling ADK and ADK Add-on"
            get-package | where Name -Like "Windows Assessment and Deployment Kit Windows Preinstallation Environment Add-ons" | Uninstall-Package -Force -ErrorAction SilentlyContinue
            get-package | where Name -Like "Windows Assessment and Deployment Kit" | Uninstall-Package -Force -ErrorAction SilentlyContinue
            Write-Host
            Write-Host " Cleanup completed"
            Write-Host
            cmd /c 'pause'
        }
        Q {
            Invoke-WebPSScript $RepositoryURL/OSDCloudUpdateMenu.ps1
        }
    }
}
While ($Select -ne "Z")