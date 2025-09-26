# DayZ Epoch Docker Container

This Docker container provides a complete DayZ Epoch server setup for Arma 2, including all necessary dependencies and configuration files.

## Prerequisites

Before building and running this container, you need:

1. **Steam Account** with ownership of:
   - Arma 2
   - Arma 2: Operation Arrowhead
   - Arma 2: British Armed Forces (optional)

2. **Docker and Docker Compose** installed on your system

3. **DayZ Epoch Server Files** (automatically downloaded during build)

## Quick Start

### 1. Configure Steam Credentials

Edit the `scripts/install_server.sh` file and replace the placeholder Steam credentials:

```bash
STEAM_USERNAME="your_steam_username"
STEAM_PASSWORD="your_steam_password"
```

### 2. Build and Run

```bash
# Clone or download this repository
cd dayz-epoch-docker

# Build and start the containers
docker-compose up --build
```

### 3. Connect to Server

The server will be available on:
- **IP**: Your server's IP address
- **Port**: 2302 (UDP)
- **Required Mods**: DayZ Epoch 1.0.7.1

## Configuration

### Server Configuration

Server configuration files are located in the `config/` directory:

- `server.cfg` - Main server configuration
- `basic.cfg` - Basic server settings
- `beserver.cfg` - BattlEye configuration

### Database Configuration

The MySQL database is automatically configured with:
- **Database**: dayz_epoch
- **Username**: dayz
- **Password**: dayz

Database schema is automatically imported from `sql/database.sql`.

### Mission Files

Place your mission files in the `missions/` directory. They will be mounted to the server's `mpmissions/` folder.

## Advanced Usage

### Manual Build

```bash
# Build the Docker image
docker build -t dayz-epoch-server .

# Run with custom configuration
docker run -d \
  --name dayz-epoch \
  -p 2302:2302/udp \
  -v $(pwd)/config:/home/dayz/server/cfgdayz \
  -v $(pwd)/missions:/home/dayz/server/mpmissions \
  dayz-epoch-server
```

### Environment Variables

The following environment variables can be configured:

- `MYSQL_HOST` - MySQL server hostname (default: mysql)
- `MYSQL_USER` - MySQL username (default: dayz)
- `MYSQL_PASSWORD` - MySQL password (default: dayz)
- `MYSQL_DATABASE` - MySQL database name (default: dayz_epoch)

## Troubleshooting

### Common Issues

1. **Steam Login Failures**
   - Verify your Steam credentials in `scripts/install_server.sh`
   - Ensure your Steam account owns the required games
   - Check if Steam Guard is enabled (may require app-specific password)

2. **File Permission Issues**
   - All filenames are automatically converted to lowercase for Linux compatibility
   - Ensure the Docker daemon has access to the build context

3. **Database Connection Issues**
   - Wait for MySQL container to fully initialize before starting the game server
   - Check MySQL logs: `docker-compose logs mysql`

4. **Server Not Starting**
   - Check server logs: `docker-compose logs dayz-epoch`
   - Verify all required files are present in the container

### Logs

Server logs are available in the `logs/` directory and can be viewed with:

```bash
docker-compose logs -f dayz-epoch
```

## File Structure

```
dayz-epoch-docker/
├── Dockerfile              # Main container definition
├── docker-compose.yml      # Multi-container setup
├── README.md               # This file
├── DOWNLOAD_INFO.md        # DayZ Epoch download information
├── config/                 # Server configuration files
│   ├── server.cfg
│   ├── basic.cfg
│   └── beserver.cfg
├── scripts/                # Installation and management scripts
│   ├── install_server.sh   # Steam and DayZ Epoch installation
│   ├── entrypoint.sh       # Container startup script
│   ├── epoch.sh            # Server startup script
│   ├── restarter.pl        # Server management script
│   └── writer.pl           # Log processing script
├── sql/                    # Database schema
│   └── database.sql
├── logs/                   # Server logs (created at runtime)
└── missions/               # Mission files (mount point)
```

## Security Considerations

1. **Change Default Passwords**: Update MySQL passwords in `docker-compose.yml`
2. **Steam Credentials**: Consider using Steam app-specific passwords
3. **Network Security**: Configure firewall rules for port 2302/UDP
4. **File Permissions**: Ensure proper file ownership and permissions

## Support

For issues related to:
- **DayZ Epoch Mod**: Visit [Epoch Mod Community](https://epochmod.com/)
- **Docker Configuration**: Check Docker documentation
- **Arma 2 Server**: Refer to Bohemia Interactive documentation

## License

This Docker configuration is provided as-is for educational and personal use. DayZ Epoch and Arma 2 are properties of their respective owners.
