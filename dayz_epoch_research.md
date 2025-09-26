# DayZ Epoch Server Requirements and Installation

## Basic Requirements

### Software Dependencies
1. **Visual C++ x86 Redistributable Packages for Visual Studio 2013**
   - Download from: http://www.microsoft.com/en-us/download/details.aspx?id=40784
   - File: vcredist_x86.exe

2. **Arma 2 Operation Arrowhead** (base game required)

3. **MySQL Server**
   - Database name: "dayz_epoch"
   - Import epoch.sql file from SQL folder

### Installation Steps
1. Install Visual C++ redistributables
2. Download client and server files, extract to Arma 2 OA root folder
3. Install MySQL server and create database
4. Configure HiveExt.ini with MySQL connection info
5. Launch with mod parameters: -mod=@DayZ_Epoch;@DayZ_Epoch_Server;

### Key Files and Folders
- HiveExt.ini (MySQL configuration)
- epoch.sql (database schema)
- Keys folder (contains bikey files for authentication)
- Config examples folder (contains .bat files)

### Server Launch Parameters
```
-mod=@DayZ_Epoch;@DayZ_Epoch_Server;
```

## Notes for Docker Implementation
- Need to handle Visual C++ dependencies (Linux alternative)
- MySQL database setup and configuration
- File permissions and "UnBlock" requirements (Windows-specific)
- Key management for authentication


## Linux Server Implementation (from GitHub)

### Repository: denisio/Dayz-Epoch-Linux-Server
- **URL**: https://github.com/denisio/Dayz-Epoch-Linux-Server
- **Version**: DayZ Epoch 1.0.5.1 server on Linux (Steam)

### Linux Dependencies
```bash
# Required packages
apt-get install perl screen mysql-server mysql-client gcc
apt-get install libjson-xs-perl libdbd-mysql-perl

# For 64-bit systems
apt-get install lib32stdc++6
```

### SteamCMD Installation Process
```bash
# Download SteamCMD
wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz

# Install Arma 2 components via SteamCMD
steamcmd/steamcmd.sh +login STEAM_USERNAME STEAM_PASSWORD +force_install_dir /home/user/epoch
@sSteamCmdForcePlatformType windows
app_update 33900 validate    # Arma 2
app_update 33910 validate    # Arma 2: OA
app_update 33930 validate    # Arma 2: British Armed Forces
app_update 219540 beta112555 validate  # Beta
quit
```

### Database Setup
```sql
mysql -u root -p mysql
create database epoch;
GRANT ALL PRIVILEGES ON epoch.* TO 'dayz'@'localhost' IDENTIFIED BY 'dayz';
use epoch;
source database.sql;
source v1042update.sql;
source v1042a_update.sql;
source v1051update.sql;
```

### Key Installation Steps
1. Run `./install` script (converts filenames to lowercase)
2. Remove all .dll files from battleye directories
3. Ensure ALL filenames are lowercase (critical for Linux)
4. Use `./restarter.pl` for production server management
5. Use `screen` for background execution

### Critical Notes for Docker
- **Case sensitivity**: All filenames MUST be lowercase
- **No DLL files**: Remove Windows-specific .dll files
- **Steam platform**: Uses Windows Steam files on Linux via compatibility
- **Perl scripts**: Server management via Perl scripts (restarter.pl)
- **MySQL integration**: Direct database connection without HIVE.dll
