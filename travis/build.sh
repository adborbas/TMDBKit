#!/bin/bash

# Variables
SDK="iphonesimulator"
workspace="TMDbKit.xcworkspace"
destination="platform=iOS Simulator,name=iPhone 7,OS=11.2"
scheme="TestAll"

# CLEAN & BUILD & TEST
xcodebuild -workspace $workspace -scheme $scheme -sdk $SDK -destination "$destination" clean build test
