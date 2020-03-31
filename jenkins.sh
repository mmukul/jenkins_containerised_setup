#!/bin/bash

# Build jenkins image based on CentOS
docker build -t myjenkins .

# Run command to create container with 8GB memory pool and connection pool for jenkins
docker run --name jenkinstest --privileged -t -i --rm myjenkins -p 8080:8080

# Populate jenkins user and password info
docker exec -it jenkinstest cat /var/lib/jenkins/secrets/initialAdminPassword