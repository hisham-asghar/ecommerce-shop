#!/bin/sh

if [ "$#" -lt 1 ]; then
  echo "Syntax: build-web.sh dev|stg|prod"
  exit
fi

TARGET="lib/main_development.dart"
if [ "$1" = "dev" ]; then
  source .env.dev
  TARGET=lib/main_development.dart
elif [ "$1" = "stg" ]; then
  source .env.stg
  TARGET=lib/main_staging.dart
elif [ "$1" = "prod" ]; then
  echo "Prod build not yet supported"
  exit
fi

# Check environment variables are set
if [ -z "$STRIPE_PUBLISHABLE_KEY" ]; then
  echo "STRIPE_PUBLISHABLE_KEY is not set"
  exit
fi
if [ -z "$SENTRY_KEY" ]; then
  echo "SENTRY_KEY is not set"
  exit
fi

flutter build web --target $TARGET --dart-define STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY --dart-define SENTRY_KEY=$SENTRY_KEY --release 
