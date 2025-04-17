# get C:\ drive free space
Write-Host ([math]::round((Get-PSDrive -Name C).Free / 1GB))"GB free space on C: drive before script execution."

# check if onedrive is installed
$onedrive = Get-Command "C:\Program Files\Microsoft OneDrive\OneDrive.exe" -ErrorAction SilentlyContinue
if ($null -eq $onedrive) {
    Write-Host "OneDrive is not installed. Exiting script." -BackgroundColor Red -ForegroundColor White
    exit
} else {
    Write-Host "OneDrive is installed."
}

# check if onedrive is running
$onedriveProcess = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue
if ($null -eq $onedriveProcess) {
    Write-Host "OneDrive is not running. Exiting script." -BackgroundColor Red -ForegroundColor White
    exit
} else {
    Write-Host "OneDrive is running."
}

# check if onedrive is signed in currently
$onedriveStatus = Get-ItemProperty "HKCU:\Software\Microsoft\OneDrive" -ErrorAction SilentlyContinue
if ($null -eq $onedriveStatus) {
    Write-Host "The registry key for OneDrive does not exist. Exiting script." -BackgroundColor Red -ForegroundColor White
    exit
} elseif ($null -eq $onedriveStatus.ClientEverSignedIn) {
    Write-Host "OneDrive has never been signed in. Exiting script." -BackgroundColor Red -ForegroundColor White
    exit
} else {
    Write-Host "OneDrive has been signed in at least once."
}

# set attribute of all files and sub-directories to 'online only' except for hidden files
attrib +U -P "$($env:OneDriveCommercial)\*" /s /d