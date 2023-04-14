#!/bin/bash
yum update -y
yum install httpd -y
echo "<h1> Hello from $(hostname -f) </h1>" > /var/www/html/index.html
systemctl restart httpd
systemctl enable httpd
