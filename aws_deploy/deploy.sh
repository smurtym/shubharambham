source ./env.sh

# Build the Rust project
cd ..
cargo build-wasm # This is aliased, refer .cargo/config.toml for details

# Navigate to the UI directory
cd ui
# Install dependencies and build the UI project
npm install
npm run build # This uses parcel to build the project, and outputs to dist/

# Deploy to AWS S3
aws s3 sync dist/ s3://$S3_BUCKET_NAME/app-v1 --delete

# Invalidate CloudFront cache
aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DISTRIBUTION_ID --paths "/*"
# Wait for invalidation to complete (optional)
# aws cloudfront wait invalidation-completed --distribution-id $CLOUDFRONT_DISTRIBUTION_ID --id <invalidation-id>
echo "Deployment completed successfully."