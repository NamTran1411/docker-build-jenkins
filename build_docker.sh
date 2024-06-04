#!/bin/bash

# Description: Script to increment Docker image version, build, and push

version_file="version.txt"

# Check if version.txt exists (improved error message)
if [[ ! -f "$version_file" ]]; then
  echo "Error: Version file '$version_file' does not exist."
  exit 1
fi

# Read the current version and handle potential errors
current_version=$(cat "$version_file") || {
  echo "Error: Could not read version from '$version_file'."
  exit 1
}

# Split version into parts using IFS (improved clarity)
IFS='.' read -r -a parts <<< "$current_version"

# Validate version format (optional, for extra robustness)
if [[ ${#parts[@]} -ne 3 || ! [[ "$major" =~ ^[0-9]+$ ]] || ! [[ "$minor" =~ ^[0-9]+$ ]] || ! [[ "$patch" =~ ^[0-9]+$ ]] ]]; then
  echo "Error: Invalid version format in '$version_file'. Expected 'major.minor.patch'."
  exit 1
fi

# Extract major, minor, and patch versions
major=${parts[0]}
minor=${parts[1]}
patch=${parts[2]}

# Increment patch version
patch=$((patch + 1))

# Create new version
new_version="$major.$minor.$patch"

# Update version file (improved error handling)
echo "$new_version" > "$version_file" || {
  echo "Error: Could not write new version to '$version_file'."
  exit 1
}

# Informative output
echo "Successfully updated version to $new_version"


version=$(cat version.txt)

ssh adminlc@192.168.64.2 "
    cd ./Documents/docker-build-jenkins &&
    git pull origin main &&
    docker build -t docker_builder:$version . &&
    docker compose up -d && docker image rm docker_builder:$current_version
"