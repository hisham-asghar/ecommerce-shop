#!/bin/sh

if [ "$#" -lt 1 ]; then
  echo "Syntax: build-web.sh dev|stg|prod"
  exit
fi

target="lib/main_development.dart"
if [ "$1" = "dev" ]; then
  flutter build web --target lib/main_development.dart --dart-define STRIPE_PUBLISHABLE_KEY=pk_test_51K3dgkIx8Zcghu6hRGpkk1AshodBflV2RBP5CcZTt9GzXKB9HeeK7oknOQw2TRdKGHOayEfeUN8JGq62s0SYreyv00uxM1oZIb --dart-define ALGOLIA_APP_ID=5O8I2IOJRG --dart-define ALGOLIA_SEARCH_KEY=80b44c96b7872ccde097b5a0fe4de054 --release 
elif [ "$1" = "stg" ]; then
  flutter build web --target lib/main_staging.dart --dart-define STRIPE_PUBLISHABLE_KEY=pk_test_51K3dgkIx8Zcghu6hRGpkk1AshodBflV2RBP5CcZTt9GzXKB9HeeK7oknOQw2TRdKGHOayEfeUN8JGq62s0SYreyv00uxM1oZIb --dart-define ALGOLIA_APP_ID=QPC7RV4O7L --dart-define ALGOLIA_SEARCH_KEY=8fb1b8744f4c12e06bbb66f5fe8b5e7b --release 
elif [ "$1" = "prod" ]; then
  echo "Prod build not yet supported"
fi


   