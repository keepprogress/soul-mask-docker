#!/bin/bash

# Workdir:  /home/steam/steamcmd
# User:     steam

VERSION="v0.2.1"
STEAMCMD="/home/steam/steamcmd/steamcmd.sh"
PLATFORM="$(cat /home/steam/steamcmd/platform)"
WS_PATH="/home/steam/soul-mask"
SOUL_MASK_DIR="/home/steam/soul-mask/WS"


# Install SoulMaskServer
install_server() {
  echo "-> Installing the server..."
  "$STEAMCMD" +force_install_dir "$WS_PATH" +login anonymous +app_update 3017300 validate +quit
}

# Whether to check for server updates
check_update() {
  if [ "$CHECK_UPDATE_ON_START" = "true" ]; then
    echo "-> Checking for updates..."
    "$STEAMCMD" +force_install_dir "$WS_PATH" +login anonymous +app_update 3017300 validate +quit
  else
    echo "-> Skipping update check."
  fi
}

print_system_info() {
  BUILD_ID=$("$STEAMCMD" +force_install_dir "$WS_PATH" +login anonymous +app_status 3017300 +quit | grep -e "BuildID" | awk '{print $8}')

  echo "----------------------------------------"
  echo "SoulMaskServer-docker: $VERSION"
  echo "Build ID: $BUILD_ID"
  echo "Author: keepprogress"
  echo "GitHub: https://github.com/keepprogress/soul-mask-docker"
  echo "----------------------------------------"
  echo "Platform: $PLATFORM"
  echo "OS: $(cat /etc/os-release | grep "^PRETTY_NAME" | cut -d'=' -f2)"
  echo "CPU: $(grep 'model name' /proc/cpuinfo | uniq | cut -d':' -f2)"
  echo "RAM: $(awk '/MemTotal/ {total=$2} /MemFree/ {free=$2} END {printf("%.2fGB/%.2fGB", (total-free)/1024000, total/1024000)}' /proc/meminfo)"
  echo "Disk Space: $(df -h / | awk 'NR==2{printf "%s/%s\n", $3, $2}')"
  echo "Startup Time: $(date)"
  echo "----------------------------------------"
}

# Set startup arguments
set_args() {
  args+=" -UTF8Output -MULTIHOME=0.0.0.0 -EchoPort=18888 -forcepassthrough -SteamServerName='ChiikawaServer' -PSW=000000 -MaxPlayers=16 -Port=8211 -adminpsw=666888 -saving=30 -backupinterval=1800 "
}

main(){
  echo "----------------------------------------"
  echo "Initializing the StartServer..."
  print_system_info


  # Check install
  if [ ! -f "$WS_PATH/StartServer.sh" ]; then
    install_server

#    # Error check
#    if [ ! -f "$WS_PATH/StartServer.sh" ]; then
#      echo "Installation failed: Please make sure to reserve at least 10GB of free disk space." >&2
#      exit 1
#    fi
  else
    check_update
  fi


  # Load startup arguments
  args=""
  set_args

  # Start server
  echo "----------------------------------------"
  echo -e "Startup Parameters: \n$SOUL_MASK_DIR/StartServer.sh $args "
  echo "----------------------------------------"
  echo "-> Starting the SoulMask..."

  cd "$WS_PATH"

  ./StartServer.sh "$args"
}

main
