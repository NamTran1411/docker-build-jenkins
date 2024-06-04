#!/bin/bash
# Description: Script to increment Docker image version, build, and push

version_file="version.txt"

# Kiểm tra xem file version.txt đã tồn tại hay chưa
if [[ ! -f "$version_file" ]]; then
    echo "Version file does exist"
    exit 0
fi


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
echo "$new_version" > "$version_file"

# In version mới ra màn hình
echo "Updated version to $new_version"
version=$(cat version.txt)
ssh adminlc@192.168.64.2 "
    cd ./Documents/docker-build-jenkins &&
    git pull origin main &&
    docker compose build --build-arg VERSION=$version &&
    docker tag docker_builder:latest docker_builder:$version
"