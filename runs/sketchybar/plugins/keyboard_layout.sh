#!/usr/bin/env bash

keyboard_layout=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | egrep -w 'KeyboardLayout Name' |sed -E 's/^.+ = \"?([^\"]+)\"?;$/\1/')

sketchybar --set "$NAME" label="$keyboard_layout"