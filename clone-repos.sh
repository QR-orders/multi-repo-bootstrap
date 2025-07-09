#!/usr/bin/env bash

# Clear default GitHub credential helper
sudo sed -i -E 's/helper =.*//' /etc/gitconfig
git config --global credential.helper '!f() { echo "username=${GITHUB_USER}"; echo "password=${GH_TOKEN}"; }; f'

mkdir -p /workspaces
cd /workspaces

while read repo; do
  name=$(basename "$repo")
  if [ -d "$name" ]; then
    echo "⚠️  Repo '$name' already exists. Skipping."
  else
    echo "🔄 Cloning $repo..."
    git clone "https://github.com/$repo.git"
  fi
done < "$(dirname "$0")/repos-to-clone.list"
