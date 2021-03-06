#!/bin/bash
# OrangeFox building script by SebaUbuntu
# You can find a list of all variables at OF_ROOT_DIR/vendor/recovery/orangefox_build_vars.txt

SCRIPT_VERSION="v3.0"

# Import common variables
source tools/variables.sh

clear
# AOSP enviroment setup
echo "AOSP environment setup, please wait..."
. build/envsetup.sh
# Enable ccache
ccache -M 20G
clear

# Ask user if a clean build is needed
printf "Do you want to do a clean build?\nAnswer: "
read CLEAN_BUILD_NEEDED

case $CLEAN_BUILD_NEEDED in
	yes|y|true|1)
		printf "\nDeleting out/ dir, please wait..."
		make clean
		sleep 2
		clear
		;;
	*)
		printf "\nClean build not required, skipping..."
		sleep 2
		clear
		;;
esac

# what device are we building for?
printf "Insert the device codename you want to build for\nCodename: "
read TARGET_DEVICE
clear

# Ask for release version
printf "Insert the version number of this release\nExample: R11.0_0\nVersion: "
read FOX_VERSION
export FOX_VERSION
clear

# Ask for release type
printf "Insert the type of this release\nPossibilities: Stable - Beta (leave empty for unofficial builds)\nRelease type: "
read FOX_BUILD_TYPE
export FOX_BUILD_TYPE
clear

logo

# Import OrangeFox build variables
source configs/${TARGET_DEVICE}_ofconfig

# TARGET_ARCH variable is needed by OrangeFox to determine which version of binary to include
if [ -z ${TARGET_ARCH+x} ]
	then
		echo "You didn't set TARGET_ARCH variable in config"
		exit
fi

# Define this value to fix graphical issues
if [ -z ${OF_SCREEN_H+x} ]
	then
		echo "You didn't set OF_SCREEN_H variable in config
This variable is needed to fix graphical issues on non-16:9 devices.
Even if you have a 16:9 device, set it anyway."
		exit
fi

# Lunch device
lunch omni_"$TARGET_DEVICE"-eng

# If lunch command fail, there is no need to continue building
if [ "$?" != "0" ]; then
	exit
fi

# Start building
mka recoveryimage
