#!/bin/bash
set -e

ARMA_PATH="/arma2"
STEAM_USER=${STEAM_USER:-anonymous}
STEAM_PASS=${STEAM_PASS:-""}
STEAM_GUARD=${STEAM_GUARD:-""}   # For 2FA codes
CONFIG=${CONFIG:-server.cfg}
PORT=${PORT:-2302}
MODS=${MODS:-""}

cd /steam

echo ">>> Logging in as $STEAM_USER"
if [ -n "$STEAM_GUARD" ]; then
  ./steamcmd.sh +@sSteamCmdForcePlatformType windows \
    +login "$STEAM_USER" "$STEAM_PASS" "$STEAM_GUARD" \
    +force_install_dir $ARMA_PATH \
    +app_update 33930 validate \
    +quit
else
  ./steamcmd.sh +@sSteamCmdForcePlatformType windows \
    +login "$STEAM_USER" "$STEAM_PASS" \
    +force_install_dir $ARMA_PATH \
    +app_update 33930 validate \
    +quit
fi

echo ">>> Starting Arma 2 OA Dedicated Server..."
cd $ARMA_PATH

exec wine arma2oaserver.exe \
  -config=$CONFIG \
  -port=$PORT \
  -mod="$MODS" \
  -name=server \
  -noSound
