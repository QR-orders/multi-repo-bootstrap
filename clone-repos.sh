#!/usr/bin/env bash
set -e

echo "🔁 [clone-repos.sh] Starting multi-repo bootstrap..."

# Configure Git to use GH_TOKEN for all HTTPS requests
sudo sed -i -E 's/helper =.*//' /etc/gitconfig
git config --global credential.helper '!f() { echo "username=${GITHUB_USER}"; echo "password=${GH_TOKEN}"; }; f'

mkdir -p /workspaces
cd /workspaces

while read -r raw_repo || [[ -n "$raw_repo" ]]; do
  # Trim whitespace + remove carriage returns
  repo=$(echo "$raw_repo" | tr -d '\r' | xargs)

  # Skip empty or comment lines
  if [[ -z "$repo" || "$repo" == \#* ]]; then
    continue
  fi

  folder=$(basename "$repo")
  if [ -d "$folder/.git" ]; then
    echo "✅ Repo '$folder' already exists. Skipping."
  else
    echo "🚀 Cloning https://github.com/$repo.git into $folder..."
    git clone "https://github.com/$repo.git" "$folder"
  fi
done < "/workspaces/multi-repo-bootstrap/repos-to-clone.list"

echo "✅ [clone-repos.sh] Done!"
