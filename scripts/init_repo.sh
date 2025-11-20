#!/usr/bin/env bash
set -e
git init -b main
git add README.md .gitignore .swiftlint.yml .github scripts docs
git commit -m "chore(repo): add README, LICENSE, .gitignore, SwiftLint and CI"
git add WeatherNowApp Core Networking Persistence Features Tests
git commit -m "feat(scaffold): add SwiftUI app, MVVM+Clean layers and tests"
echo "Repo initialized. Next: create Xcode project (README step 1) and push to GitHub."
