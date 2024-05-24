#!/bin/bash
# Description: Script to increment Docker image version, build, and push the image to Docker Hub.

# Ensure the increment_version script is executable
chmod +x increment_version.sh

# Increment the version
./increment_version.sh

# Read the new version
version=$(cat version.txt)
if [ -z "$version" ]; then
  echo "Error reading version. Exiting."
  exit 1
fi

# Define the Docker image name
image_name="docker_builder"

# Build the Docker image with the new version tag
docker build -t $image_name:$version .

# Login to Docker Hub (use environment variables for credentials)
if echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin; then
  echo "Docker login successful."
else
  echo "Docker login failed."
  exit 1
fi

# Push the image to Docker Hub
if docker push $image_name:$version; then
  echo "Docker image pushed successfully."
else
  echo "Failed to push Docker image."
  exit 1
fi
