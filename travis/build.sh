#!/bin/bash

# Variables
SDK="iphonesimulator"
workspace="TMDbKit.xcworkspace"
destination='platform=iOS Simulator,name=iPhone 7,OS=11.2'

# CLEAN
xcodebuild -workspace $workspace -scheme BuildAll -sdk $SDK clean

if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
  # Nightly BUILD
  # Integration Tests
  xcodebuild -workspace $workspace -scheme IntegrationTests -sdk $SDK -destination $destination test
else
  # PullRequest BUILD
  # BUILD ALL
  xcodebuild -workspace $workspace -scheme BuildAll -sdk $SDK -destination $destination
  # UNIT Tests
  xcodebuild -workspace $workspace -scheme UnitTests -sdk $SDK -destination $destination test
fi
