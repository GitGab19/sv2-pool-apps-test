#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INTEGRATION_DIR="$REPO_ROOT/integration-test-framework/sv2-integration-test-framework-test"

echo "🧪 Running integration tests for sv2-miner-apps-test changes..."
echo "📁 Repository root: $REPO_ROOT"
echo "📁 Integration test dir: $INTEGRATION_DIR"

mkdir -p "$REPO_ROOT/integration-test-framework"

# Clone/update integration test framework
if [ ! -d "$INTEGRATION_DIR" ]; then
    echo "📥 Cloning integration test framework..."
    cd "$(dirname "$INTEGRATION_DIR")"
    git clone https://github.com/GitGab19/sv2-integration-test-framework-test.git
else
    echo "🔄 Updating integration test framework..."
    cd "$INTEGRATION_DIR"
    git fetch origin
    git reset --hard origin/main
fi

cd "$INTEGRATION_DIR"

# Backup original Cargo.toml
cp Cargo.toml Cargo.toml.backup

# Update sv2-miner-apps-test dependencies to use local path
echo "🔧 Updating dependencies to use local sv2-pool-apps-test..."

# Use sed to replace git dependencies with local path dependencies
sed -i '' 's|jd_server = { git = "https://github.com/GitGab19/sv2-pool-apps-test", branch = "main" }|jd_server = { path = "../../jd-server" }|g' Cargo.toml
sed -i '' 's|pool_sv2 = { git = "https://github.com/GitGab19/sv2-pool-apps-test", branch = "main" }|pool_sv2 = { path = "../../pool" }|g' Cargo.toml

echo "✅ Updated Cargo.toml to use local dependencies"
echo "🏃 Running integration tests..."

# Run the integration tests
cargo test --features sv1 --verbose

cd "$REPO_ROOT"
echo "✅ Integration tests completed!"