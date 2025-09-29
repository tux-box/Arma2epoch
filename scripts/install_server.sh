#!/bin/bash

# Exit on error
set -e

# Steam credentials (replace with your own)
STEAM_USERNAME=""
STEAM_PASSWORD=""

# Arma 2 App IDs
APP_ID_ARMA2=33900
APP_ID_ARMA2_OA=33910
APP_ID_ARMA2_BAF=33930
APP_ID_ARMA2_BETA=219540

# DayZ Epoch Download URLs (replace with direct links if they expire)
DAYZ_EPOCH_SERVER_URL="https://drive.usercontent.google.com/download?id=1jDn86sfTwcRae4NZgHK76k_CaY1jOUP2&export=download&authuser=0&confirm=t&uuid=cb6e7fff-bfbd-405a-87ec-49c0be383ed9&at=AN8xHop3GRLPgRW9vGwJTjWerRji%3A1758904112974"
DAYZ_EPOCH_SERVER_PASSWORD="123456"

# Installation directory
INSTALL_DIR="/home/dayz/server"

# 1. Install Arma 2 using SteamCMD
echo "Installing Arma 2..."
/home/dayz/steamcmd/steamcmd.sh +force_install_dir $INSTALL_DIR \
    +login $STEAM_USERNAME $STEAM_PASSWORD \
    +@sSteamCmdForcePlatformType windows \
    +app_update $APP_ID_ARMA2 validate \
    +app_update $APP_ID_ARMA2_OA validate \
    +app_update $APP_ID_ARMA2_BAF validate \
    +app_update $APP_ID_ARMA2_BETA beta112555 validate \
    +quit

# 2. Download and extract DayZ Epoch server files
echo "Downloading and extracting DayZ Epoch server..."
cd /tmp
wget -O dayz_epoch_server.7z "$DAYZ_EPOCH_SERVER_URL"
7z x -p$DAYZ_EPOCH_SERVER_PASSWORD dayz_epoch_server.7z -o$INSTALL_DIR/@dayz_epoch_server
rm dayz_epoch_server.7z

# 3. Download and extract DayZ Epoch client files (for @dayz_epoch mod)
echo "Downloading and extracting DayZ Epoch client..."
DAYZ_EPOCH_CLIENT_URL="https://drive.usercontent.google.com/download?id=19iCJevU008g311vsxJNR0PjYmkSv36YK&export=download&authuser=0&confirm=t&uuid=a2e10166-8211-4f24-b7d7-7a80cbdd654b&at=AN8xHop414tzyCUH6oOVjSHuiYAS%3A1758904039424"
wget -O dayz_epoch_client.7z "$DAYZ_EPOCH_CLIENT_URL"
7z x dayz_epoch_client.7z -o$INSTALL_DIR/@dayz_epoch
rm dayz_epoch_client.7z

echo "Installation complete."

