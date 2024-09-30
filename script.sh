#!/bin/bash

USERNAME="shahram"
PASSWORD="1234567890"

echo "Enter 1 for Saiman, and 2 for IDK:"
read input

if [ "$input" -eq 1 ]; then
    choice="b"
elif [ "$input" -eq 2 ]; then
    choice="i"
else
    echo "Invalid input."
    exit 1
fi

echo "Updating package list..."
apt update

echo "Installing display manager"
apt install -y lubuntu-desktop

# Install xRDP for remote desktop access
echo "Installing xRDP for remote access..."
apt install -y xrdp
systemctl enable xrdp
systemctl start xrdp

echo "Installing software-properties-common..."
apt install -y software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa

# Update package list again after adding PPA
echo "Updating package list again..."
apt update

# Install Python 3.10
echo "Installing Python 3.10..."
apt install -y python3.10 python3.10-venv python3.10-distutils

echo "Installing vscode"
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
apt install -y code

echo "Installing chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb

echo "Installing edge"
wget https://packages.microsoft.com/keys/microsoft.asc -O microsoft.asc
apt-key add microsoft.asc
echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" | tee /etc/apt/sources.list.d/microsoft-edge.list
apt update
apt install -y microsoft-edge-stable

echo "Making edge default browser"
xdg-settings set default-web-browser microsoft-edge.desktop

echo "Creating user"
useradd -m -s /bin/bash "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

mkdir -p "/home/$USERNAME"

echo "Creating project setup file"
cat <<EOL > "/home/$USERNAME/script.sh"
#!/bin/bash

mkdir -p Desktop/app
cd Desktop/app

echo "Cloning yolo"
git clone "https://github.com/Mohamad-Golden/image-recognition-$choice.git"
mv "image-recognition-$choice" yolo

echo "Creating venv"
python3.10 -m venv venv
source ./venv/bin/activate

echo "Installing python deps"
pip install -r yolo/requirements.txt
EOL

chmod +x "/home/$USERNAME/script.sh"


echo "Installation complete. Rebooting the server..."
reboot
