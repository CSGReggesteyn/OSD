Clear-host
Write-Host " ***************************"
Write-Host " *   Upload OSDCloud ISO   *"
Write-Host " ***************************"
Write-Host

### Check if AZCopy is installed
if (-NOT ((Test-Path -path $env:APPDATA\AzCopy\azcopy.exe -PathType Leaf)) {
    ### Installing AzCopy
    Write-Host " Installing AZCopy"
    Write-Host
    Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile "$DownloadsPath\AzCopy.zip" -UseBasicParsing
    Expand-Archive "$DownloadsPath\AzCopy.zip" "$DownloadsPath\AzCopy" -Force
    mkdir $env:APPDATA\AzCopy
    Get-ChildItem "$DownloadsPath\AzCopy\*\azcopy.exe" | Move-Item -Destination $env:APPDATA\AzCopy\
    Remove-Item -Force "$DownloadsPath\AzCopy.zip"
    Remove-Item -Force -Recurse "$DownloadsPath\AzCopy\"
} Else {

}
Write-Host " Make sure the ISO location/name = $DownloadsPath\OSDCloud_NoPrompt.iso"
Write-Host
cmd /c 'pause'

### Starting the AzCopy action to upload the file
Write-Host " Uploading OSDCloud ISO to cloud storage"
Invoke-Expression "& '$env:APPDATA\AzCopy\azcopy.exe' login"
try {
    Invoke-Expression  "& '$env:APPDATA\AzCopy\azcopy.exe' copy '$DownloadsPath\OSDCloud_NoPrompt.iso' $ISOURL" -ErrorAction SilentlyContinue | Out-Null
} catch {
    Write-Host " Upload failed, error massage:"
    Write-Host
    Write-host "$error" -ForegroundColor red
    Write-Host
    cmd /c 'pause'
}