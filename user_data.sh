#!/bin/bash
yum update -y
yum install -y python3 git
pip3 install flask mysql-connector-python gunicorn

cd /home/ec2-user/student_app

# Export environment variables (auto-injected by Terraform)
echo "export DB_HOST=${rds_endpoint}" >> /etc/profile
echo "export DB_USER=admin" >> /etc/profile
echo "export DB_PASSWORD=${db_password}" >> /etc/profile
echo "export DB_NAME=student_db" >> /etc/profile
source /etc/profile

# Start Gunicorn
nohup gunicorn app:app -b 0.0.0.0:5000 > /home/ec2-user/gunicorn.log 2>&1 &
