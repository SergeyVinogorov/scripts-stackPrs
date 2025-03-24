#!/bin/bash

# Check if all required arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <base-branch> <new-branch-name> <commit-message> <commit-hash>"
    exit 1
fi

# Assign arguments to variables
BASE_BRANCH=$1
NEW_BRANCH=$2
COMMIT_MSG=$3
COMMIT_HASH=$4

# Ensure we are in a Git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: This is not a Git repository."
    exit 1
fi

# Stash uncommitted changes before switching branches (optional)
git add .
git commit -m "$COMMIT_MSG"

# Switch to the base branch
git checkout "$BASE_BRANCH"

# Pull the latest changes
git pull origin "$BASE_BRANCH"

# Create a new branch from the base branch
git checkout -b "$NEW_BRANCH"

# Cherry-pick the specified commit
git cherry-pick "$COMMIT_HASH"

# Check if cherry-pick was successful
if [ $? -ne 0 ]; then
    echo "Cherry-pick failed. Resolve conflicts and commit manually."
    exit 1
fi

echo "Branch '$NEW_BRANCH' created from '$BASE_BRANCH', and commit '$COMMIT_HASH' cherry-picked successfully."
