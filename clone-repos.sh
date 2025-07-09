#!/usr/bin/env bash
set -e

echo "🔁 [clone-repos.sh] Starting multi-repo bootstrap..."

# Set up Git credentials using GH_TOKEN
sudo sed -i -E 's/helper =.*//' /etc/gitconfig
git config --global credential.helper '!f() { echo "username=${GITHUB_USER}"; echo "password=${GH_TOKEN}"; }; f'

mkdir -p /workspaces
cd /workspaces

while read -r raw_repo || [[ -n "$raw_repo" ]]; do
  # Trim whitespace and strip carriage returns
  entry=$(echo "$raw_repo" | tr -d '\r' | xargs)

  # Skip blank or comment lines
  if [[ -z "$entry" || "$entry" == \#* ]]; then
    continue
  fi

  # Extract repo name and optional branch
  repo_name=$(echo "$entry" | cut -d'@' -f1)
  branch_name=$(echo "$entry" | cut -s -d'@' -f2)
  folder=$(basename "$repo_name")

  if [ -d "$folder/.git" ]; then
    echo "🔄 '$folder' already cloned. Pulling latest on current branch..."
    cd "$folder"
    git pull --rebase --autostash
    cd ..
  else
    echo "🚀 Cloning https://github.com/$repo_name.git into $folder (branch: ${branch_name:-main})..."
    git clone --branch "${branch_name:-main}" "https://github.com/$repo_name.git" "$folder"
  fi
done < "$HOME/workspaces/multi-repo-bootstrap/repos-to-clone.list"

echo "✅ [clone-repos.sh] Done!"
