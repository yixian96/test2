# ================================
# User-Space Nmap Installation
# No Administrator Required
# ================================

$NmapVersion = "7.95"
$NmapZipUrl  = "https://nmap.org/dist/nmap-$NmapVersion-win32.zip"
$ToolsDir    = "$env:USERPROFILE\tools"
$NmapDir     = "$ToolsDir\nmap"
$ZipPath     = "$env:TEMP\nmap.zip"

Write-Host "[*] Creating tools directory..."
New-Item -ItemType Directory -Force -Path $NmapDir | Out-Null

Write-Host "[*] Downloading Nmap $NmapVersion..."
Invoke-WebRequest -Uri $NmapZipUrl -OutFile $ZipPath -UseBasicParsing

Write-Host "[*] Extracting Nmap..."
Expand-Archive -Path $ZipPath -DestinationPath $NmapDir -Force

# Locate extracted folder
$ExtractedDir = Get-ChildItem $NmapDir | Where-Object { $_.PSIsContainer } | Select-Object -First 1
$NmapExePath  = Join-Path $ExtractedDir.FullName "nmap.exe"

if (Test-Path $NmapExePath) {
    Write-Host "[+] Nmap installed successfully in user space"
    Write-Host "[+] Location: $($ExtractedDir.FullName)"
} else {
    Write-Host "[-] Nmap executable not found. Installation may be blocked."
    exit 1
}

Write-Host "[*] Testing Nmap execution..."
& $NmapExePath --version