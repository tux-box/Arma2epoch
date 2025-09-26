# DayZ Epoch Docker Deployment Guide

This comprehensive guide provides step-by-step instructions for deploying a DayZ Epoch server using Docker containers.

## System Requirements

### Hardware Requirements
- **CPU**: Minimum 2 cores, recommended 4+ cores
- **RAM**: Minimum 4GB, recommended 8GB+
- **Storage**: Minimum 20GB free space for game files
- **Network**: Stable internet connection with UDP port 2302 accessible

### Software Requirements
- **Operating System**: Linux (Ubuntu 18.04+ recommended)
- **Docker**: Version 20.10 or later
- **Docker Compose**: Version 1.29 or later
- **Steam Account**: With ownership of Arma 2 and Arma 2: Operation Arrowhead

## Pre-Deployment Setup

### 1. Steam Account Configuration

Before proceeding, ensure your Steam account meets these requirements:

**Required Games**:
- Arma 2 (Steam App ID: 33900)
- Arma 2: Operation Arrowhead (Steam App ID: 33910)
- Arma 2: British Armed Forces (Steam App ID: 33930) - Optional

**Steam Guard Considerations**:
If Steam Guard is enabled on your account, you may need to:
- Use an app-specific password
- Temporarily disable Steam Guard during installation
- Use Steam's mobile authenticator for login verification

### 2. Server Environment Preparation

**Install Docker and Docker Compose**:
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
```

**Configure Firewall**:
```bash
# Allow DayZ Epoch server port
sudo ufw allow 2302/udp
sudo ufw allow 3306/tcp  # MySQL (if accessing externally)
```

## Deployment Process

### Step 1: Download and Configure

```bash
# Clone or download the DayZ Epoch Docker setup
git clone <repository-url> dayz-epoch-docker
cd dayz-epoch-docker

# Configure Steam credentials
nano scripts/install_server.sh
```

**Edit the following variables in `scripts/install_server.sh`**:
```bash
STEAM_USERNAME="your_steam_username"
STEAM_PASSWORD="your_steam_password"
```

### Step 2: Customize Server Configuration

**Server Settings** (`config/server.cfg`):
```cfg
hostname = "Your DayZ Epoch Server";
password = "";
passwordAdmin = "your_admin_password";
maxPlayers = 50;
```

**Basic Configuration** (`config/basic.cfg`):
```cfg
language="English";
adapter=-1;
3D_Performance=1.000000;
Resolution_W=0;
Resolution_H=0;
Resolution_Bpp=32;
```

**Database Configuration** (`docker-compose.yml`):
```yaml
environment:
  MYSQL_ROOT_PASSWORD: your_secure_root_password
  MYSQL_PASSWORD: your_secure_dayz_password
```

### Step 3: Deploy the Server

**Using Docker Compose (Recommended)**:
```bash
# Build and start all services
docker-compose up --build -d

# Monitor logs
docker-compose logs -f
```

**Manual Docker Build**:
```bash
# Build the image
docker build -t dayz-epoch-server .

# Run MySQL container
docker run -d \
  --name dayz-mysql \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=dayz_epoch \
  -e MYSQL_USER=dayz \
  -e MYSQL_PASSWORD=dayz \
  -v mysql_data:/var/lib/mysql \
  mysql:5.7

# Run DayZ Epoch server
docker run -d \
  --name dayz-epoch \
  --link dayz-mysql:mysql \
  -p 2302:2302/udp \
  -v $(pwd)/config:/home/dayz/server/cfgdayz \
  -v $(pwd)/missions:/home/dayz/server/mpmissions \
  dayz-epoch-server
```

## Post-Deployment Configuration

### 1. Verify Server Status

```bash
# Check container status
docker-compose ps

# View server logs
docker-compose logs dayz-epoch

# Check MySQL connectivity
docker-compose exec mysql mysql -u dayz -p dayz_epoch
```

### 2. Server Administration

**Access Server Console**:
```bash
# Attach to server screen session
docker-compose exec dayz-epoch screen -r epoch
```

**Restart Server**:
```bash
# Restart specific service
docker-compose restart dayz-epoch

# Restart all services
docker-compose restart
```

**Update Server**:
```bash
# Pull latest changes and rebuild
git pull
docker-compose down
docker-compose up --build -d
```

### 3. Mission File Management

**Adding Custom Missions**:
```bash
# Copy mission files to missions directory
cp your_mission.pbo missions/

# Restart server to load new missions
docker-compose restart dayz-epoch
```

**Mission Configuration**:
Edit `config/server.cfg` to specify available missions:
```cfg
class Missions
{
    class DayZ_Epoch_11
    {
        template="DayZ_Epoch_11.Chernarus";
        difficulty="Regular";
    };
};
```

## Monitoring and Maintenance

### Performance Monitoring

**Resource Usage**:
```bash
# Monitor container resource usage
docker stats

# Check disk usage
docker system df
```

**Server Performance**:
```bash
# Monitor server logs for performance issues
docker-compose logs -f dayz-epoch | grep -E "(fps|performance|lag)"

# Check player count and server status
docker-compose exec dayz-epoch cat /home/dayz/server/logs/server.log
```

### Backup Procedures

**Database Backup**:
```bash
# Create database backup
docker-compose exec mysql mysqldump -u dayz -p dayz_epoch > backup_$(date +%Y%m%d).sql

# Restore database backup
docker-compose exec -T mysql mysql -u dayz -p dayz_epoch < backup_20231201.sql
```

**Configuration Backup**:
```bash
# Backup entire configuration
tar -czf dayz-epoch-backup-$(date +%Y%m%d).tar.gz config/ missions/ docker-compose.yml
```

### Log Management

**Log Rotation**:
```bash
# Configure Docker log rotation
echo '{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}' | sudo tee /etc/docker/daemon.json

sudo systemctl restart docker
```

## Troubleshooting

### Common Issues and Solutions

**1. Steam Authentication Failures**
```bash
# Check Steam credentials
docker-compose logs dayz-epoch | grep -i steam

# Verify account ownership
# Ensure Steam Guard is properly configured
```

**2. Database Connection Issues**
```bash
# Check MySQL container status
docker-compose ps mysql

# Test database connectivity
docker-compose exec mysql mysql -u dayz -p -e "SHOW DATABASES;"

# Reset database
docker-compose down
docker volume rm dayz-epoch-docker_mysql_data
docker-compose up -d
```

**3. Server Not Responding**
```bash
# Check server process
docker-compose exec dayz-epoch ps aux | grep epoch

# Verify port binding
netstat -tulpn | grep 2302

# Check firewall settings
sudo ufw status
```

**4. File Permission Issues**
```bash
# Fix file permissions
docker-compose exec dayz-epoch chown -R dayz:dayz /home/dayz/server
docker-compose exec dayz-epoch chmod +x /home/dayz/server/*.sh
```

### Performance Optimization

**Server Performance Tuning**:
```bash
# Adjust server parameters in epoch.sh
-cpucount=4 -exThreads=7 -maxMem=4096
```

**Database Optimization**:
```yaml
# Add to docker-compose.yml MySQL service
command: --innodb-buffer-pool-size=1G --innodb-log-file-size=256M
```

## Security Considerations

### Network Security
- Configure firewall to only allow necessary ports
- Use strong passwords for all services
- Consider VPN access for administrative functions
- Regularly update Docker images and host system

### Access Control
- Implement proper admin password policies
- Use BattlEye for anti-cheat protection
- Monitor server logs for suspicious activity
- Regularly backup and test restore procedures

### Data Protection
- Encrypt sensitive configuration files
- Use Docker secrets for password management
- Implement regular automated backups
- Test disaster recovery procedures

## Support and Resources

### Official Documentation
- [DayZ Epoch Official Website](https://epochmod.com/)
- [Arma 2 Server Documentation](https://community.bistudio.com/wiki/Arma_2)
- [Docker Documentation](https://docs.docker.com/)

### Community Resources
- [Epoch Mod Community Forums](https://epochmod.com/forum/)
- [DayZ Mod Reddit](https://www.reddit.com/r/DayZmod/)
- [Arma Community](https://forums.bohemia.net/)

### Technical Support
For technical issues specific to this Docker implementation, check the project repository issues or create a new issue with detailed logs and system information.
