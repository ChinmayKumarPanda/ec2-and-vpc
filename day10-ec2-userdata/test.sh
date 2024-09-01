#!/bin/bash

# Update the package index
sudo yum update -y

# Install NGINX
sudo amazon-linux-extras install nginx1.12 -y

# Start the NGINX service
sudo systemctl start nginx

# Enable NGINX to start on boot
sudo systemctl enable nginx

# Optional: Create a simple HTML page
echo "<html><h1>Welcome to NGINX on EC2!</h1></html>" | sudo tee /usr/share/nginx/html/index.html

# Restart NGINX to apply any changes
sudo systemctl restart nginx
