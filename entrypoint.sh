#!/bin/bash

# Exit on error
set -e

# 1. Configure and start MySQL
echo "Starting MySQL..."
service mysql start

# 2. Create database and user
mysql -u root -e "CREATE DATABASE IF NOT EXISTS dayz_epoch;"
mysql -u root -e "CREATE USER IF NOT EXISTS 'dayz'@'localhost' IDENTIFIED BY 'dayz';"
mysql -u root -e "GRANT ALL PRIVILEGES ON dayz_epoch.* TO 'dayz'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# 3. Import database schema
echo "Importing database schema..."
mysql -u dayz -pdayz dayz_epoch < /home/dayz/server/sql/database.sql

# 4. Start the DayZ Epoch server
echo "Starting DayZ Epoch server..."
cd /home/dayz/server
./restarter.pl

# 5. Keep the container running
tail -f /dev/null

