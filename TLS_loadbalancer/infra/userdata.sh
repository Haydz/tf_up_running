#!/bin/bash
sudo apt install net-tools -y
sudo apt-get install -y busybox  
cat > index.html <<EOF
<h1>HELLOWORLD</h1>
EOF

nohup busybox httpd -f -p 8080 &


