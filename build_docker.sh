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


current_version=$(cat "$version_file")

# Tách version thành major, minor và patch
IFS='.' read -r -a parts <<< "$current_version"
major=${parts[0]}
minor=${parts[1]}
patch=${parts[2]}

# Tăng giá trị patch
patch=$((patch + 1))

# Tạo version mới
new_version="$major.$minor.$patch"

# Lưu version mới vào file


# In version mới ra màn hình
echo "Updated version to $new_version"


# version=$(cat version.txt)

ssh adminlc@192.168.64.2 "
    cd ./Documents/docker-build-jenkins &&
    git pull origin main &&
    docker build -t docker_builder:$new_version . &&
    docker compose up -d && docker image rm docker_builder:$current_version &&
    echo $new_version > version.txt
"