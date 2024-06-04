#!/bin/bash

# Description: Script to increment Docker image version, build, and push
# Version file path
version_file="version.txt"

if [[ -f "$version_file" ]]; then
  # Read the current version from the file
  current_version=$(cat "$version_file")
  IFS='.' read -r -a parts <<< "$current_version"
  major=${parts[0]}
  minor=${parts[1]}
  patch=${parts[2]}

  # Tăng giá trị patch
  patch=$((patch + 1))

  # Tạo version mới
  new_version="$major.$minor.$patch"

  echo $new_version > version.txt
else
  current_version="1.0.0"
  touch version.txt
  echo $current_version > version.txt
  echo "Version is already 1.0.0. Not incrementing."
  new_version="$current_version"
fi

echo "Current version: $current_version"
# In version mới ra màn hình
echo "Updated version to $new_version"

# SSH execution with conditional docker image removal
ssh adminlc@192.168.64.2 << EOF
    cd ./Documents/docker-build-jenkins &&
    git pull origin main &&
    docker build -t docker_builder:$new_version . &&
    docker compose up -d


    if [[ $new_version != "1.0.0" ]]; then
      docker image rm docker_builder:$current_version
    fi
EOF

echo "Script execution completed on remote server."