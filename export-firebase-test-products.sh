#!/bin/bash

# Start emulator
# https://superuser.com/questions/178587/how-do-i-detach-a-process-from-terminal-entirely
firebase emulators:start --export-on-exit=./firebase-exports/seed-test-products

# Generate products
#curl http://localhost:8081/my-shop-ecommerce-dev/us-central1/generateProductList

#lsof -ti :8081 | xargs kill