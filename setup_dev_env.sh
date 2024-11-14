#!/bin/bash

# ==========================================
# Development Environment Setup Script
# ==========================================
# This script sets up a cross-platform development environment on both Mac and Windows.
# It checks for the presence of each tool before attempting installation, ensuring idempotency.
#
# How to Run:
# - Save this script as `setup_dev_env.sh`
# - On Mac:
#     1. Open Terminal.
#     2. Navigate to the script's directory.
#     3. Make the script executable: `chmod +x setup_dev_env.sh`
#     4. Run the script: `./setup_dev_env.sh`
# - On Windows:
#     1. Install Git Bash or WSL (Windows Subsystem for Linux) if not already installed.
#     2. Open Git Bash or a WSL terminal.
#     3. Navigate to the script's directory.
#     4. Run the script: `./setup_dev_env.sh`
# ==========================================

# Check and Install Package Managers
if [[ "$OSTYPE" == "darwin"* ]]; then
    # MacOS: Install Homebrew
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
elif [[ "$OSTYPE" == "msys"* ]]; then
    # Windows: Install Chocolatey using CURL
    if ! command -v choco &>/dev/null; then
        echo "Installing Chocolatey..."
        curl -fsSL https://community.chocolatey.org/install.ps1 -o install_choco.ps1
        powershell -ExecutionPolicy Bypass -File install_choco.ps1
        rm install_choco.ps1
    fi
fi

install_tool() {
    if ! command -v "$1" &>/dev/null; then
        echo "Installing $1..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install "$2"
        elif [[ "$OSTYPE" == "msys"* ]]; then
            choco install "$3" -y
        fi
    else
        echo "$1 is already installed. Checking for updates..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # Determine if it's a formula or cask and update accordingly
            if brew list --formula | grep -q "^$2$"; then
                echo "Updating $1 as a formula..."
                brew upgrade "$2"
            elif brew list --cask | grep -q "^$2$"; then
                echo "Updating $1 as a cask..."
                brew upgrade --cask "$2"
            else
                echo "$1 is installed, but it could not be identified as a formula or cask."
            fi
        elif [[ "$OSTYPE" == "msys"* ]]; then
            echo "Updagrding $1..."
            choco upgrade "$3" -y
        fi
    fi
}

install_cask_app() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Check if the cask app is installed in Applications folder
        if [[ ! -d "/Applications/$2.app" ]]; then
            echo "Installing $1..."
            brew install --cask "$2"
        else
            echo "$1 is already installed. Updating $1..."
            brew upgrade --cask "$2"
        fi
    elif [[ "$OSTYPE" == "msys"* ]]; then
        # Windows: Use Chocolatey to install or update
        if ! choco list --local-only | grep -q "^$3 "; then
            echo "Installing $1..."
            choco install "$3" -y
        else
            echo "$1 is already installed. Updating $1..."
            choco upgrade "$3" -y
        fi
    fi
}

# Function to add a command to PATH if not already present
add_to_path() {
    local cmd_name="$1"
    local cmd_path="$2"

    if ! command -v "$cmd_name" &>/dev/null; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS: Create a symlink in /usr/local/bin
            if [[ -e "$cmd_path" ]]; then
                echo "Adding $cmd_name to PATH..."
                sudo ln -s "$cmd_path" /usr/local/bin/"$cmd_name"
            else
                echo "$cmd_name not found at $cmd_path. Please check the installation path."
            fi
        elif [[ "$OSTYPE" == "msys"* ]]; then
            # Windows: Output instructions to add manually
            echo "Please ensure the $cmd_name command is added to PATH on Windows."
            echo "You may need to add $cmd_path to PATH manually."
        fi
    else
        echo "$cmd_name is already available in PATH."
    fi
}


# Install Languages and Frameworks
install_tool "Dotnet SDK" "dotnet-sdk" "dotnet-sdk"
install_tool "Node.js" "node" "nodejs"
install_tool "TypeScript" "typescript" "typescript"

# Database Installation
install_tool "PostgreSQL" "postgresql" "postgresql"

# Development Tools
install_tool "Git" "git" "git"
install_tool "Docker" "docker" "docker"
install_tool "Docker Compose" "docker-compose" "docker-compose"
install_tool "Visual Studio Code" "visual-studio-code" "vscode"
install_tool "GitHub Desktop" "github" "github-desktop"
install_tool "Docker Desktop" "docker" "docker-desktop"

# Ensure the commands are available by adding it to PATH if missing
add_to_path "code" "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"

# VS Code Extensions Array
vscode_extensions=(
    "smcpeak.default-keys-windows"
    "ms-azuretools.vscode-docker"
    "msjsdiag.vscode-react-native"
    "dart-code.dart-code"
    "ms-vscode-remote.remote-containers"
    "dart-code.flutter"
    "ms-vscode.powershell"
    "planbcoding.vscode-react-refactor"
    "ms-dotnettools.csdevkit"
    # Add other extensions here as needed
)

install_vscode_extension() {
    if ! code --list-extensions | grep -q "$1"; then
        echo "Installing VS Code extension: $1"
        code --install-extension "$1"
    else
        echo "VS Code extension $1 is already installed. Checking for updates..."
        code --install-extension "$1" --force
    fi
}




# Install VS Code Extensions if `code` is available
if command -v code &>/dev/null; then
    for extension in "${vscode_extensions[@]}"; do
        install_vscode_extension "$extension"
    done
else
    echo "VS Code CLI (code command) not found. Skipping extension installation."
fi


# Placeholder for Future Repository Downloads
# echo "This section can be expanded to clone repositories from GitHub."

# VS Code Config Synchronization
# Add code here to copy VS Code settings to a consistent location
 
