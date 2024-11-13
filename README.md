# Development Environment Setup Script

This script sets up a cross-platform development environment on both macOS and Windows, installing essential development tools, frameworks, databases, and VS Code extensions. It ensures idempotency by checking for the presence of each tool before attempting installation, and updating existing packages where possible.

## Features

- **Cross-Platform Support**: Works on macOS and Windows.
- **Automatic Package Manager Setup**:
  - Installs Homebrew on macOS if missing.
  - Installs Chocolatey on Windows if missing.
- **Idempotent Installation**: Checks if each tool is installed before proceeding, updating if already present.
- **Custom PATH Addition**: Adds commands to PATH if missing, using a reusable `add_to_path` function.
- **VS Code Extension Management**: Installs or updates a specified list of VS Code extensions.

## How to Use

### 1. Clone or Download the Script

Download or clone the repository and navigate to the script directory.

### 2. Run the Script

#### On macOS:
1. Open Terminal.
2. Navigate to the script's directory.
3. Make the script executable:
   ```bash
   chmod +x setup_dev_env.sh
   ```
4. Run the script:
   ```bash
   ./setup_dev_env.sh
   ```

#### On Windows:
1. Install Git Bash or WSL (Windows Subsystem for Linux) if not already installed.
2. Open Git Bash or a WSL terminal.
3. Navigate to the script's directory.
4. Run the script:
   ```bash
   ./setup_dev_env.sh
   ```

## Components Installed by the Script

### Languages and Frameworks
- **.NET SDK** (`dotnet-sdk`)
- **Node.js**
- **TypeScript**

### Database
- **PostgreSQL**

### Development Tools
- **Git**
- **Docker**
- **Visual Studio Code**
- **GitHub Desktop**

### VS Code Extensions
The script installs or updates the following VS Code extensions:
- `smcpeak.default-keys-windows`
- `ms-azuretools.vscode-docker`

To add more extensions, update the `vscode_extensions` array in the script.

## Custom PATH Addition

The `add_to_path` function allows you to add any command to PATH if it’s not already available. Currently, the script ensures that the `code` command for VS Code is available on macOS.

## Future Customizations

- **Repository Cloning**: Placeholder for automating repository downloads.
- **VS Code Configuration Sync**: Placeholder for copying VS Code settings across machines.

## Troubleshooting

- **"Command not found"**: Ensure the script is run in an environment with either Homebrew (macOS) or Chocolatey (Windows).
- **PATH Errors**: For Windows, ensure `code` is manually added to PATH if the script doesn’t do so automatically.
