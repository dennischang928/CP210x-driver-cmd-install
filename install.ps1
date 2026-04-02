$ErrorActionPreference = 'Stop'

$zip = "$env:TEMP\CP210x_Windows_Drivers.zip"
$dir = "$env:TEMP\CP210x_Windows_Drivers"

Invoke-WebRequest "https://www.silabs.com/documents/public/software/CP210x_Windows_Drivers.zip" -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $dir -Force

if ([Environment]::Is64BitOperatingSystem) {
    $exe = Join-Path $dir "CP210xVCPInstaller_x64.exe"
} else {
    $exe = Join-Path $dir "CP210xVCPInstaller_x86.exe"
}

Start-Process $exe -ArgumentList '/Q','/SE' -Verb RunAs -Wait