#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# capture_screenshots.sh
# Captures Play Store screenshots from a running Android emulator.
#
# USAGE:
#   1. Start the app on an emulator:  flutter run
#   2. Navigate to the screen you want
#   3. Run:  bash scripts/capture_screenshots.sh <name>
#      e.g.  bash scripts/capture_screenshots.sh home
#            bash scripts/capture_screenshots.sh learn_A
#            bash scripts/capture_screenshots.sh play_quiz
#            bash scripts/capture_screenshots.sh trace_A
#            bash scripts/capture_screenshots.sh onboarding
# ─────────────────────────────────────────────────────────────────────────────

set -e

SCREENSHOT_DIR="$(dirname "$0")/../store/screenshots"
mkdir -p "$SCREENSHOT_DIR"

NAME="${1:-screenshot_$(date +%H%M%S)}"
OUTPUT="$SCREENSHOT_DIR/${NAME}.png"

echo "📸 Capturing screenshot → $OUTPUT"
adb exec-out screencap -p > "$OUTPUT"
echo "✅ Saved: $OUTPUT"
open "$SCREENSHOT_DIR"
