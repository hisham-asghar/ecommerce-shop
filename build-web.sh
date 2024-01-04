#!/bin/sh

if [ "$#" -lt 1 ]; then
  echo "Syntax: build-web.sh dev|stg|prod"
  exit
fi

target="lib/main_development.dart"
if [ "$1" = "dev" ]; then
  flutter build web --target lib/main_development.dart --dart-define STRIPE_PUBLISHABLE_KEY=pk_test_51K3dgkIx8Zcghu6hRGpkk1AshodBflV2RBP5CcZTt9GzXKB9HeeK7oknOQw2TRdKGHOayEfeUN8JGq62s0SYreyv00uxM1oZIb --release 
elif [ "$1" = "stg" ]; then
  flutter build web --target lib/main_staging.dart --dart-define STRIPE_PUBLISHABLE_KEY=pk_test_51K3dgkIx8Zcghu6hRGpkk1AshodBflV2RBP5CcZTt9GzXKB9HeeK7oknOQw2TRdKGHOayEfeUN8JGq62s0SYreyv00uxM1oZIb --release 
elif [ "$1" = "prod" ]; then
  echo "Prod build not yet supported"
fi