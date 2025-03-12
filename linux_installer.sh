#!/bin/bash

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Check if Git is installed
if command -v git &> /dev/null
then
    # Git is installed, check the version
    INSTALLED_VERSION=$(git --version | awk '{print $3}')
    LATEST_VERSION=$(apt-cache policy git | grep Candidate | awk '{print $2}')

    echo "Installed Git version: $INSTALLED_VERSION"
    echo "Latest Git version: $LATEST_VERSION"

    if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]
    then
        echo "Updating Git to the latest version..."
        sudo apt install --only-upgrade git -y
    else
        echo "Git is already installed and up to date."
    fi
else
    # Git is not installed, install it
    echo "Git is not installed. Installing Git..."
    sudo apt install git -y
fi

# Check if snap is installed
if command -v snap &> /dev/null
then
    echo "Snap is already installed."
else
    echo "Snap is not installed. Installing Snap..."
    sudo apt install snapd -y
fi

# Check if VS Code is installed
if dpkg -l | grep code &> /dev/null
then
    echo "Visual Studio Code is already installed."
else
    echo "Visual Studio Code is not installed. Installing Visual Studio Code..."

    # Download the .deb package
    wget -q https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb

    # Install the .deb package
    sudo dpkg -i vscode.deb

    # Fix any dependency issues
    sudo apt -f install -y

    # Clean up
    rm vscode.deb
fi

# Check if Node.js is installed
if command -v node &> /dev/null
then
    # Node.js is installed, check version
    INSTALLED_VERSION=$(node -v)
    echo "Node.js is already installed. Version: $INSTALLED_VERSION"

    # Check if Node.js version is outdated
    NODE_LATEST_VERSION=$(curl -sL https://nodejs.org/dist/latest/SHASUMS256.txt | awk '{print $2}' | sed 's/node-v//; s/.tar.xz//' | head -n 1)
    if [[ "$INSTALLED_VERSION" != *"$NODE_LATEST_VERSION"* ]]
    then
        echo "Updating Node.js to the latest version using NVM..."
        # Install NVM if not already installed
        if ! command -v nvm &> /dev/null
        then
            echo "Installing NVM..."
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
            # Activate NVM in current shell session
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        fi

        # Install latest Node.js version using NVM
        nvm install node --latest-npm
        nvm use node
    else
        echo "Node.js is already installed and up to date."
    fi
else
    # Node.js is not installed, install it using NVM
    echo "Node.js is not installed. Installing Node.js using NVM..."
    # Install NVM if not already installed
    if ! command -v nvm &> /dev/null
    then
        echo "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
        # Activate NVM in current shell session
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi

    # Install latest Node.js version using NVM
    nvm install node --latest-npm
    nvm use node
fi

# Function to install or update Express.js
install_or_update_express() {
    if npm list -g express &> /dev/null
    then
        # Express.js is installed, check if update is needed
        INSTALLED_VERSION=$(npm list -g --depth=0 express | grep express@ | sed 's/.*express@\([^ ]*\).*/\1/')
        LATEST_VERSION=$(npm show express version)
        
        if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]
        then
            echo "Updating Express.js to the latest version..."
            npm update -g express
        else
            echo "Express.js is already installed and up to date. Version: $INSTALLED_VERSION"
        fi
    else
        # Express.js is not installed, install it
        echo "Installing Express.js..."
        npm install -g express
    fi
}

# Function to install or update Vue.js
install_or_update_vue() {
    if npm list -g @vue/cli &> /dev/null
    then
        # Vue.js is installed, check if update is needed
        INSTALLED_VERSION=$(npm list -g --depth=0 @vue/cli | grep @vue/cli@ | sed 's/.*@vue\/cli@\([^ ]*\).*/\1/')
        LATEST_VERSION=$(npm show @vue/cli version)
        
        if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]
        then
            echo "Updating Vue.js to the latest version..."
            npm update -g @vue/cli
        else
            echo "Vue.js is already installed and up to date. Version: $INSTALLED_VERSION"
        fi
    else
        # Vue.js is not installed, install it
        echo "Installing Vue.js..."
        npm install -g @vue/cli
    fi
}

# Function to install or update React.js
install_or_update_react() {
    if npm list -g create-react-app &> /dev/null
    then
        # React.js is installed, check if update is needed
        INSTALLED_VERSION=$(npm list -g --depth=0 create-react-app | grep create-react-app@ | sed 's/.*create-react-app@\([^ ]*\).*/\1/')
        LATEST_VERSION=$(npm show create-react-app version)
        
        if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]
        then
            echo "Updating React.js to the latest version..."
            npm update -g create-react-app
        else
            echo "React.js is already installed and up to date. Version: $INSTALLED_VERSION"
        fi
    else
        # React.js is not installed, install it
        echo "Installing React.js..."
        npm install -g create-react-app
    fi
}

#Function to install or update pnpm
install_or_update_pnpm() {
    if npm list -g pnpm &> /dev/null
    then
        #pnpm is installed, check if update is needed
        INSTALLED_VERSION=$(npm list -g --depth=0 pnpm | grep pnpm@ | sed 's/.*pnpm@\([^ ]*\).*/\1/')
        LATEST_VERSION=$(npm show pnpm version)

        if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]
        then
            echo "Updating pnpm to the latest version..."
            npm update -g pnpm
        else
            echo "pnpm is already installed and up to date. Version: $INSTALLED_VERSION"
        fi
    else
        #pnpm are not installed
        echo "Installing pnpm..."
        npm install -g pnpm
    fi
}

#Function to install or update express-generator
install_or_update_express-generator() {
    if npm list -g express-generator &> /dev/null
    then
        #express-generator is installed and check if update is needed
        INSTALLED_VERSION=$(npm list -g --depth=0 express-generator | grep express-generator@ | sed 's/.*express-generator@\([^ ]*\).*/\1/')
        LATEST_VERSION=$(npm show express-generator version)

        if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]
        then
            echo "Updating express-generator to the latest version..."
            npm update -g express-generator
        else
            echo "express-generator is already installed and up to date. Version: $INSTALLED_VERSION"
        fi
    else
        #express-generator are not installed
        echo "Installing express-generator"
        npm install -g express-generator
    fi
}

# Main function to choose and install tech stack
choose_tech_stack() {
    echo "Choose a tech stack to install:"
    echo "1. Express.js"
    echo "2. Vue.js"
    echo "3. React.js"
    echo "4. pnpm"
    echo "5. express-generator"
    echo "6. Exit"

    read -p "Enter your choice (enter the number): " choice

    case $choice in
        1) install_or_update_express ;;
        2) install_or_update_vue ;;
        3) install_or_update_react ;;
	    4) install_or_update_pnpm ;;
        5) install_or_update_express-generator ;;
        6) echo "Exiting..." ;;
        *) echo "Invalid choice. Please enter a valid option." ;;
    esac
}

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install tech stack
choose_tech_stack