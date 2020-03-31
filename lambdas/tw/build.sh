#!/bin/sh

LAMBDA_ZIP_FILE=lambda.zip
PROJECT_ROOT_DIR=tw-syncer
TERRAFORM_DIR=$(pwd)

cd "$TERRAFORM_DIR/$PROJECT_ROOT_DIR"

npm i && npm run build:lambda && cp "$TERRAFORM_DIR/$PROJECT_ROOT_DIR/dist/lambda.zip" $TERRAFORM_DIR
