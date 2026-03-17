#!/bin/bash
# setup-skills: Provision Skills to .cursor/skills/ or .agents/skills/
# Low-side: clone from GITLAB_URL. High-side: copy from pre-synced path.
#
# Env vars: GITLAB_URL, GITLAB_TOKEN, SKILLS_REPO_PATH (optional)
# As of March 2026.

set -e

SKILLS_DIR="${HOME}/.cursor/skills"
mkdir -p "$SKILLS_DIR"

if [ -n "$SKILLS_REPO_PATH" ] && [ -d "$SKILLS_REPO_PATH" ]; then
  # High-side: copy from pre-synced path
  echo "Copying Skills from pre-synced path: $SKILLS_REPO_PATH"
  cp -r "$SKILLS_REPO_PATH"/* "$SKILLS_DIR/" 2>/dev/null || true
elif [ -n "$GITLAB_URL" ] && [ -n "$GITLAB_TOKEN" ]; then
  # Low-side: clone from GitLab (replace with actual Skills repo URL)
  SKILLS_REPO="${GITLAB_URL}/platform/skills.git"
  echo "Cloning Skills from $SKILLS_REPO"
  git clone --depth 1 "https://oauth2:${GITLAB_TOKEN}@${SKILLS_REPO#https://}" "$SKILLS_DIR/skills-repo" || true
  if [ -d "$SKILLS_DIR/skills-repo" ]; then
    cp -r "$SKILLS_DIR/skills-repo"/* "$SKILLS_DIR/" 2>/dev/null || true
  fi
else
  echo "No Skills source configured. Set SKILLS_REPO_PATH or GITLAB_URL+GITLAB_TOKEN."
fi

echo "Skills directory: $SKILLS_DIR"
ls -la "$SKILLS_DIR" 2>/dev/null || true
