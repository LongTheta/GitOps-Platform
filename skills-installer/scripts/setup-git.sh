#!/bin/bash
# setup-git: Configure Git from environment variables
# Required for Skills installer when cloning from GitLab
#
# Env vars: GITLAB_URL, GIT_USER_NAME, GIT_USER_EMAIL, GITLAB_TOKEN
# As of March 2026.

set -e

if [ -z "$GIT_USER_NAME" ] || [ -z "$GIT_USER_EMAIL" ]; then
  echo "Error: GIT_USER_NAME and GIT_USER_EMAIL must be set"
  exit 1
fi

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

if [ -n "$GITLAB_URL" ] && [ -n "$GITLAB_TOKEN" ]; then
  # Configure credential helper for GitLab
  git config --global credential.helper store
  echo "git config for $GITLAB_URL configured (token from GITLAB_TOKEN)"
fi

echo "Git configured: $GIT_USER_NAME <$GIT_USER_EMAIL>"
