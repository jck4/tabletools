#!/bin/sh
set -e

cd $CI_PRIMARY_REPOSITORY_PATH

# 🚀 Ensure we're on the correct branch (fixed method)
git fetch origin
DEFAULT_BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')

# Only checkout if not already on the correct branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "$DEFAULT_BRANCH" ]; then
    git checkout $DEFAULT_BRANCH
fi

# 🛠️ Install Flutter
echo "📦 Installing Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$HOME/flutter/bin:$PATH"

# 🛠️ Pre-cache iOS artifacts
flutter precache --ios

# 🛠️ Install Flutter dependencies
flutter pub get

# 🛠️ Install CocoaPods only if missing
if ! command -v pod &> /dev/null
then
    echo "📦 Installing CocoaPods..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods
else
    echo "✅ CocoaPods already installed."
fi

# 🛠️ Install CocoaPods dependencies
cd ios && pod install --repo-update

exit 0
