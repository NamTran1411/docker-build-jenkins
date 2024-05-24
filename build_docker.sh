#!/bin/bash
# Description: Script to increment Docker image version, build, and push the image to Docker Hub.

# Ensure the increment_version script is executable
chmod +x increment_version.sh
# Read the new version
version=$(cat version.txt)
ssh adminlc@192.168.64.2 "
    cd ./Documents/docker-build-jenkins &&
    git pull origin main &&
    docker compose build --build-arg VERSION=$version &&
    docker compose up
"