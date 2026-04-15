#!/bin/bash
# Author Ashrafuzzaman | ashrafdiu1973@gmail.com

# Runs inside Bitbucket pipelines. Creates a tar bundle for our project
# and stores it in AWS S3 Bucket. Then creates a new deployment using
# AWS CodeDeploy.

# --- Configuration ---
# Ensure these are set in Bitbucket Repository Settings:
# S3_BUCKET (e.g., laravel12devops)
# APPLICATION_NAME
# DEPLOYMENT_CONFIG_NAME
# DEPLOYMENT_GROUP_NAME

HASH=$(git rev-parse --short HEAD)
BUNDLE="$HASH.tar.gz"

# Clean up any old local bundles
rm -f bundle-*.tar.gz

echo "[-] Creating bundle: $BUNDLE"

# Create the archive based on bundle.conf
tar \
  --exclude='*.git*' \
  --exclude='storage/logs/*' \
  --exclude='vendor/*' \
  --exclude='bootstrap/cache/*' \
  --exclude='artifact/*' \
  --exclude='.styleci.yml' \
  --exclude='.env' \
  -zcf "$BUNDLE" -T bundle.conf > /dev/null 2>&1

# Upload to S3
# Note: We use the s3:// protocol here because 'aws s3 cp' requires it.
echo "[-] Uploading to S3..."
aws s3 cp "$BUNDLE" "s3://$S3_BUCKET/bundles/$BUNDLE" > /dev/null 2>&1

echo "[-] Deployment starting for revision: $HASH"

# --- The Fix ---
# For 'create-deployment', the 'bucket' parameter must be ONLY the name.
# The 'key' parameter is the path inside that bucket.
aws deploy create-deployment \
  --application-name "$APPLICATION_NAME" \
  --deployment-config-name "$DEPLOYMENT_CONFIG_NAME" \
  --deployment-group-name "$DEPLOYMENT_GROUP_NAME" \
  --file-exists-behavior OVERWRITE \
  --s3-location bucket="$S3_BUCKET",bundleType=tgz,key="bundles/$BUNDLE"
