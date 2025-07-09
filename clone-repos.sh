#!/usr/bin/env bash
set -e

echo "🔁 [clone-repos.sh] Starting multi-repo bootstrap..."

# Ensure Git uses token for all clones
sudo sed -i -E 's/helper =.*//' /etc/gitconfig
git config --global credential.helper '!f() { echo "username=${GITHUB_USER}"; echo "password=${GH_TOKEN}"; }; f'

mkdir -p /workspaces
cd /workspaces

# Read repo list from the bootstrap repo root, not /workspaces
while read -r repo; do
  name=$(basename "$repo")
  if [ -d "$name/.git" ]; then
    echo "✅ Repo '$name' already exists. Skipping."
  else
    echo "🚀 Cloning $repo..."
    git clone "https://github.com/$repo.git"
  fi
done < "$HOME/workspaces/multi-repo-bootstrap/repos-to-clone.list"

echo "✅ [clone-repos.sh] Done!"
