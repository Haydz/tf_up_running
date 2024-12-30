#!/bin/bash

# Install busybox if not already installed
# if ! command -v busybox &> /dev/null; then
sudo apt-get update
sudo apt-get install -y busybox  # Use 'apt-get' or another package manager as needed
# fi
cat > index.html <<EOF
<h1>${server_text}</h1>
<p>DB address: ${db_address}</p>
<p>DB port: ${db_port}</p>
EOF

nohup busybox httpd -f -p ${server_port} &


