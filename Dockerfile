# Use base image with dynamic version
ARG BASEIMAGE_VERSION
FROM jlesage/baseimage-gui:ubuntu-22.04-v${BASEIMAGE_VERSION}

# Set working directory
WORKDIR /app

# Accept the Cura version as a build argument (defaults to latest version)
ARG CURA_VERSION=latest
ENV CURA_VERSION=${CURA_VERSION}

# Install necessary dependencies for running Cura
RUN apt update --fix-missing && \
    apt install -y \
    curl \
    dbus-x11 \
    jq \
    libegl1-mesa \
    libgl1-mesa-glx \
    nano \
    openbox \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Fetch the AppImage URL from GitHub based on the specified version
RUN curl -s "https://api.github.com/repos/Ultimaker/Cura/releases" | \
    jq -r --arg VERSION "$CURA_VERSION" '.[] | select(.tag_name == $VERSION) | .assets[] | select(.name | test("X64\\.AppImage$")) | .browser_download_url' > /app/download_url && \
    wget -i /app/download_url

# Extract the AppImage (note: AppImage is typically Linux-only)
RUN chmod +x *.AppImage && \
    ./*linux-X64.AppImage --appimage-extract

# Create necessary directories and set proper permissions for the app
RUN mkdir -p /app/input /app/output && \
    chown -R 1000:1000 /app/input /app/output && \
    chmod -R 755 /app/input /app/output

# Create a non-root user with a fixed UID and GID
RUN useradd -ms /bin/bash --uid 1000 --gid 1000 cura_user

# Set environment variable for the Cura application name
ENV APP_NAME="Cura"

# Make the non-root user the default user to run the application
USER cura_user

# Expose the port for the VNC interface (if you're running Cura with VNC)
EXPOSE 5800

# Copy the startup script to the container (you will need to create this)
COPY ./startapp.sh /startapp.sh

# Set the script to be executable
RUN chmod +x /startapp.sh

# Command to start the app via the extracted AppImage
ENTRYPOINT ["/startapp.sh"]
