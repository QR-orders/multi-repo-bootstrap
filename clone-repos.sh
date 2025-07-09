#!/usr/bin/env bash
set -e

echo "🔁 [clone-repos.sh] Starting multi-repo bootstrap..."

# Configure Git to use GH_TOKEN
sudo sed -i -E 's/helper =.*//' /etc/gitconfig
git config --global credential.helper '!f() { echo "username=${GITHUB_USER}"; echo "password=${GH_TOKEN}"; }; f'

mkdir -p /workspaces
cd /workspaces

while read -r repo; do
  folder=$(basename "$repo")
  if [ -d "$folder/.git" ]; then
    echo "✅ '$folder' already exists. Skipping."
  else
    echo "🚀 Cloning $repo into $folder..."
    git clone "https://github.com/$repo.git" "$folder"
  fi
done < "$HOME/workspaces/multi-repo-bootstrap/repos-to-clone.list"

echo "✅ [clone-repos.sh] Done!"
