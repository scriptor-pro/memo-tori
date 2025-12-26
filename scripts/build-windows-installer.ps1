$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$version = $env:VERSION
if (-not $version) { $version = "0.1.0" }

$distDir = Join-Path $root "dist"
$buildDir = Join-Path $distDir "memo-tori"
$venvDir = Join-Path $root ".venv-win"

if (Test-Path $buildDir) { Remove-Item $buildDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

if (-not (Test-Path $venvDir)) {
  python -m venv $venvDir
}

& "$venvDir\Scripts\pip" install --upgrade pip | Out-Null
& "$venvDir\Scripts\pip" install -r "$root\requirements.txt" pyinstaller | Out-Null

& "$venvDir\Scripts\pyinstaller" \
  --noconfirm \
  --name "memo-tori" \
  --windowed \
  --add-data "$root\web;web" \
  --add-data "$root\assets;assets" \
  "$root\app.py"

$exeSource = Join-Path $root "dist\memo-tori\memo-tori.exe"
if (-not (Test-Path $exeSource)) {
  throw "Executable not found at $exeSource"
}

$issTemplate = Get-Content "$root\packaging\windows\installer.iss" -Raw
$issContent = $issTemplate.Replace("__VERSION__", $version).Replace("__SOURCE_DIR__", $root)
$issPath = Join-Path $root "dist\memo-tori-installer.iss"
Set-Content -Path $issPath -Value $issContent -Encoding ASCII

$inno = Get-Command "iscc" -ErrorAction SilentlyContinue
if (-not $inno) {
  throw "Inno Setup (iscc.exe) not found. Install Inno Setup and ensure iscc is in PATH."
}

& $inno.Path $issPath

Write-Host "Built installer in $distDir"
