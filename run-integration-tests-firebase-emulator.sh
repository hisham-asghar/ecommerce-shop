#!/bin/bash

# Start emulator with seed data
firebase emulators:start --import=./firebase-exports/seed-test-products &

# Run integration tests (Android emulator)
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/purchase_flow_firebase_emulator_test.dart --flavor=development -d emulator-5554
# Run integration tests (iOS Simulator)
#flutter drive --driver=test_driver/integration_test.dart --target=integration_test/purchase_flow_firebase_emulator_test.dart --flavor=development -d 628E745E-6A0E-48CA-8CDF-7943DC1ECE8A

## Kill emulator when done
lsof -ti :8081 | xargs kill # functions


# Relevant Q/A
# https://superuser.com/questions/178587/how-do-i-detach-a-process-from-terminal-entirely
# https://stackoverflow.com/questions/62684701/how-can-i-shut-down-the-local-firebase-emulators

