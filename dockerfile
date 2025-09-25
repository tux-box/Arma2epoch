FROM ubuntu:22.04

# Install Wine + dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
    wine32 \
    winbind \
    xvfb \
    cabextract \
    unzip \
    curl \
    wget \
    lib32gcc-s1 \
    lib32stdc++6 \
    ca-certificates \
    tini && \
    rm -rf /var/lib/apt/lists/*

# Install SteamCMD (Linux, but we’ll force Windows platform)
RUN mkdir -p /steam && \
    cd /steam && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# Prepare Arma2 directory
RUN mkdir -p /arma2
WORKDIR /arma2

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose Arma2 server ports
EXPOSE 2302/udp 2303/udp 2305/udp 8766/udp 27016/udp

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
