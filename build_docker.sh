#!/bin/bash

# Description: Script to increment Docker image version, build, and push
# Version file path
version_file="version.txt"

if [[ -f "$version_file" ]]; then
  # Read the current version from the file
  current_version=$(cat "$version_file")
else
  # Create a new version.txt file with initial version 1.0.0
  echo "1.0.0" > "$version_file"
  current_version="1.0.0"
fi

echo "Current version: $current_version"

# Check if version needs incrementing (skip if 1.0.0)
if [[ "$current_version" != "1.0.0" ]]; then
  # Tách version thành major, minor và patch
  IFS='.' read -r -a parts <<< "$current_version"
  major=${parts[0]}
  minor=${parts[1]}
  patch=$((patch + 1))

  # Tạo version mới
  new_version="$major.$minor.$patch"
else
  echo "Version is already 1.0.0. Not incrementing."
  new_version="$current_version"  # Keep version as 1.0.0
fi



# In version mới ra màn hình
echo "Updated version to $new_version"

# SSH execution with conditional docker image removal
ssh adminlc@192.168.64.2 << EOF
    cd ./Documents/docker-build-jenkins &&
    git pull origin main &&
    docker build -t --no-cache docker_builder:$new_version . &&
    docker compose up -d

    if [[ -f $version_file ]]; then
      echo "File 'version_file' exits."
      echo $new_version > version.txt
    else
     # Actions to take if version_file doesn't exist
      touch version.txt && echo $new_version > version.txt
    fi

    if [[ $new_version != "1.0.0" ]]; then
      docker image rm docker_builder:$current_version
    fi
EOF

echo "Script execution completed on remote server."