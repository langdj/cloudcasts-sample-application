#!/usr/bin/env bash

# Production assets/dependencies
npm install
npm run production
composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

# TODO: Generate a .env file

# Create our build artifact
git archive -o builds/cloudcasts.zip --worktree-attributes HEAD
zip -qur builds/cloudcasts.zip vendor
zip -qur builds/cloudcasts.zip public
zip -qur builds/cloudcasts.zip .env

# Upload artifact to s3
aws s3 cp builds/cloudcasts.zip s3://cloudcasts-$1-artifacts/$CODEBUILD_RESOLVED_SOURCE_VERSION.zip 