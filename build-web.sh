#!/bin/sh

if [ "$#" -lt 1 ]; then
  echo "Syntax: build-web.sh dev|stg|prod"
  exit
fi

target="lib/main_development.dart"
if [ "$1" = "dev" ]; then
  target="lib/main_development.dart"
elif [ "$1" = "stg" ]; then
  target="lib/main_staging.dart"
elif [ "$1" = "prod" ]; then
  target="lib/main_production.dart"
fi

flutter build web --target "$target" --dart-define STRIPE_PUBLISHABLE_KEY=pk_test_51K3dgkIx8Zcghu6hRGpkk1AshodBflV2RBP5CcZTt9GzXKB9HeeK7oknOQw2TRdKGHOayEfeUN8JGq62s0SYreyv00uxM1oZIb --release 
   