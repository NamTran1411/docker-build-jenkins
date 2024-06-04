#!/bin/bash


# SSH server details (replace with your actual values)
SSH_SERVER="adminlc@192.168.64.2"

# Connect to SSH server
ssh $SSH_SERVER << EOF  # EOF prevents local command interpretation

  git pull origin main

  version_file="version.txt"

  if [[ ! -f "$version_file" ]]; then
    echo "Version file does not exist. Creating with initial version 1.0.0"
    echo "1.0.0" > $version_file
  fi


  current_version=$(cat $version_file)

  echo "Current version: $current_version"

  IFS='.' read -r -a parts <<< "$current_version"
  major=${parts[0]}
  minor=${parts[1]}
  patch=$((patch + 1))

  new_version="$major.$minor.$patch"


  echo "Updated version to $new_version"

  cd ./Documents/docker-build-jenkins

  docker build -t docker_builder:$new_version .

  docker compose up -d && docker image rm docker_builder:$current_version

EOF

# Optional: Update version file locally (if not done remotely)
# echo "$new_version" > "$version_file"  # Uncomment if needed

echo "Script execution completed on remote server."