#!/bin/sh
set -e

cd $CI_PRIMARY_REPOSITORY_PATH

# 🚀 Ensure we're on the correct branch
git fetch origin
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

# Only checkout if not already on the correct branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "$DEFAULT_BRANCH" ]; then
    git checkout $DEFAULT_BRANCH
fi

export PATH="$PATH:$HOME/flutter/bin"

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# Install Flutter dependencies.
flutter pub get

# Install CocoaPods only if it's not already installed.
if ! command -v pod &> /dev/null
then
    echo "📦 Installing CocoaPods..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods
else
    echo "✅ CocoaPods already installed."
fi

# Install CocoaPods dependencies.
cd ios && pod install --repo-update

exit 0
