#!/bin/sh

# Ensure User and Group IDs
if id -u game >/dev/null 2>&1 ; then
    echo "User game exists."
else
    echo "User game does not exist, create it!"
	groupadd game
	useradd -m -g game game
fi
if [ ! "$(id -u game)" -eq "$UID" ]; then usermod -o -u "$UID" game ; fi
if [ ! "$(id -g game)" -eq "$GID" ]; then groupmod -o -g "$GID" game ; fi

# Install SteamCMD
if [ ! -f /data/steam/steamcmd.sh ]
then
  echo "Downloading SteamCMD..."
  mkdir -p /data/steam/
  mkdir -p /data/game/
  cd /data/steam/
  wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" -O steam.tar.gz
  tar zxvf steam.tar.gz
  rm steam.tar.gz
  chown -R game:game /data/steam
  chown -R game:game /data/game
fi

# Update game
echo "Updating Game..."
su game -s /bin/sh -p -c "/data/steam/steamcmd.sh +force_install_dir /data/game +login anonymous +app_update 380870 +quit"

# Install OpenJ9
echo "Checking OpenJDK..."
if [ ! -d /data/java ]
then
  mkdir -p /data/java
  cd /data/java
  wget "https://github.com/ibmruntimes/semeru17-binaries/releases/download/jdk-17.0.5%2B8_openj9-0.35.0/ibm-semeru-open-jre_x64_linux_17.0.5_8_openj9-0.35.0.tar.gz" -O jdk.tar.gz
  tar zxvf jdk.tar.gz
  rm jdk.tar.gz
  mv jdk-17.0.5+8-jre jre64
  chown -R game:game /data/java
fi

# Patch
echo "Patching..."
cd /data/game
rm -r jre64
su game -s /bin/sh -p -c "ln -s /data/java/jre64 /data/game/jre64"

# Start server
echo "Launching server..."
cd /data/game
su game -s /bin/sh -p -c "./start-server.sh -adminpassword ${ADMINPASSWD}"