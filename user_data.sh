#!/bin/bash
yum update -y
yum install -y python3 git
pip3 install flask mysql-connector-python gunicorn

# Start Gunicorn
cd /home/ec2-user/student_app
nohup gunicorn app:app -b 0.0.0.0:5000 > /home/ec2-user/gunicorn.log 2>&1 &
