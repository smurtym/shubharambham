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
aws s3 sync dist/ $S3_PATH --delete

# Invalidate CloudFront cache if needed