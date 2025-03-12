# PowerShell Script for Windows Setup

# Function to check if a program is installed
function Check-Installed {
    param (
        [string]$command
    )
    $exists = Get-Command $command -ErrorAction SilentlyContinue
    return $null -ne $exists
}

# Update system (Windows doesn't have direct apt equivalent, so we skip this part)

# Install Chocolatey if not installed
if (-not (Check-Installed "choco")) {
    Write-Host "Chocolatey is not installed. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Refresh environment
$env:Path += ";C:\ProgramData\chocolatey\bin"

# Check and Install Git
if (Check-Installed "git") {
    Write-Host "Git is already installed."
} else {
    Write-Host "Installing Git..."
    choco install git -y
}

# Check and Install VS Code
if (Check-Installed "code") {
    Write-Host "VS Code is already installed."
} else {
    Write-Host "Installing VS Code..."
    choco install vscode -y
}

# Check and Install NVM for Windows
if (-not (Test-Path "$env:LOCALAPPDATA\nvm\nvm.exe")) {
    Write-Host "Installing NVM for Windows..."
    choco install nvm -y
}

# Refresh environment
$env:Path += ";$env:LOCALAPPDATA\nvm"

# Install or Update Node.js using NVM
$nvmInstalled = Test-Path "$env:LOCALAPPDATA\nvm\nvm.exe"
if ($nvmInstalled) {
    Write-Host "NVM is installed. Checking Node.js..."
    $nodeInstalled = Check-Installed "node"
    if ($nodeInstalled) {
        $installedVersion = node -v
        Write-Host "Node.js is installed. Version: $installedVersion"
    } else {
        Write-Host "Installing latest Node.js using NVM..."
        nvm install latest
        nvm use latest
    }
} else {
    Write-Host "NVM installation failed. Please install it manually."
}

# Function to install or update an npm package globally
function Install-Or-Update-NpmPackage {
    param (
        [string]$package
    )
    if (npm list -g $package --depth=0 | Select-String $package) {
        $installedVersion = npm list -g --depth=0 $package | Select-String $package | ForEach-Object { ($_ -split "@")[1] }
        $latestVersion = npm show $package version

        if ($installedVersion -ne $latestVersion) {
            Write-Host "Updating $package to the latest version..."
            npm update -g $package
        } else {
            Write-Host "$package is already up to date. Version: $installedVersion"
        }
    } else {
        Write-Host "Installing $package..."
        npm install -g $package
    }
}

# Function to choose tech stack
function Choose-TechStack {
    Write-Host "Choose a tech stack to install:"
    Write-Host "1. Express.js"
    Write-Host "2. Vue.js"
    Write-Host "3. React.js"
    Write-Host "4. pnpm"
    Write-Host "5. express-generator"
    Write-Host "6. Exit"

    $choice = Read-Host "Enter your choice (enter the number)"

    switch ($choice) {
        "1" { Install-Or-Update-NpmPackage "express" }
        "2" { Install-Or-Update-NpmPackage "@vue/cli" }
        "3" { Install-Or-Update-NpmPackage "create-react-app" }
        "4" { Install-Or-Update-NpmPackage "pnpm" }
        "5" { Install-Or-Update-NpmPackage "express-generator" }
        "6" { Write-Host "Exiting..." }
        default { Write-Host "Invalid choice. Please enter a valid option." }
    }
}

# Run tech stack installation
Choose-TechStack
