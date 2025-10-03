FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=non-interactive

# Update package list and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    openssh-server \
    sudo \
    systemd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create demo user with password
RUN useradd -m -s /bin/bash demo && \
    echo 'demo:notadmin' | chpasswd && \
    usermod -aG sudo demo

# Configure SSH
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "AllowUsers demo" >> /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
