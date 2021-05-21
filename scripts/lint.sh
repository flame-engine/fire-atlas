#!/usr/bin/env bash

function run_lint {
  FORMAT_ISSUES=$(flutter format --set-exit-if-changed -n .)
  if [ $? -eq 1 ]; then
    echo "flutter format issues on"
    echo $FORMAT_ISSUES
    exit 1
  fi

  flutter pub get

  result=$(flutter analyze .)
  if ! echo "$result" | grep -q "No issues found!"; then
    echo "$result"
    echo "flutter analyze issue: $1"
    exit 1
  fi

  echo "success"
}

cd fire_atlas_editor
run_lint

exit 0
