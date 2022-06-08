#!/bin/bash

DISTRO=$(grep '^NAME' /etc/os-release)

func_reboot_now () {
	read -p "Do you want to reboot now? [Y/n] " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		sudo restart
		exit 1
	fi
}

# Debian specific snap install 
func_debian_snap_available() {
	if ! command -v snap &> /dev/null
	then
		echo "Snap unavilable, installing it."
		sudo apt install snapd -y
		systemctl enable --now snapd apparmor
	fi
	
	# Checking again if PATH isn't set
	if ! command -v snap &> /dev/null
	then
		echo "Please restart your system now"
		exit 1
	fi
}

func_snap_install () {
	sudo snap install chromium

	sudo snap install spotify
	sudo snap install pycharm-community --classic
	sudo snap install phpstorm --classic
	sudo snap install intellij-idea-community --classic
	sudo snap install clion --classic
	sudo snap install rider --classic
	sudo snap install rubymine --classic
	
	sudo snap install flutter --classic
	sudo snap install android-studio --classic
	sudo snap install eclipse --classic

	sudo snap install mumble
	sudo snap install flameshot
	sudo snap install joplin-desktop
	sudo snap install bitwarden
	sudo snap install lolcat
	sudo snap install nextcloud-desktop-client
}

func_debian_basic () {
	sudo apt install vim nano gcc g++ cmake cmake unzip git -y
	sudo apt install libfuse2 -y
	sudo apt install gnome-tweaks gnome-shell-extensions gnome-boxes -y
	sudo apt install neofetch -y
}

echo "===== Meowosaurus is lazy ====="
echo "Do not use this installer if you"
echo "didn't check the bash code. "
echo "==============================="

read -p "Are you sure you want to continue? [Y/n] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo "Exiting.."
	exit 1
fi

# Checking if user is root OR user is using "sudo"
if [[ $USER == "root" ]]
then
	echo "Please do NOT run as root, this includes sudo!"
    	exit 1
fi

case $DISTRO in
	"NAME=\"Pop!_OS\"")
		sudo apt update
		sudo apt upgrade -y
		
		# functions
		func_debian_basic 
		func_debian_snap_available
		func_snap_install 
		func_reboot_now 
		
		printf "\n\n#Added by LazyInstaller script\nneofetch | lolcat" >> /home/$USER/.bashrc
		
		exit 1
	;;
	"NAME=\"Kali GNU/Linux\"")
		sudo apt update
		sudo apt upgrade -y
		
		# functions
		func_debian_basic 
		func_debian_snap_available
		func_snap_install 
		func_reboot_now 
		
		printf "\n\n#Added by LazyInstaller script\nneofetch | lolcat" >> /home/$USER/.zshrc

		exit 1
	;;
	"NAME=\"Ubuntu\"")
		sudo apt update
		sudo apt upgrade -y
		
		# functions
		func_debian_basic 
		func_debian_snap_available
		func_snap_install
		
		curl -fsSL https://get.docker.com -o get-docker.sh
		sudo sh get-docker.sh
		rm get-docker.sh
		 
		func_reboot_now 
		
		printf "\n\n#Added by LazyInstaller script\nneofetch | lolcat" >> /home/$USER/.bashrc

		exit 1
	;;
	*)
		echo "Unsupported OS!"
		exit 1
	;;
esac
