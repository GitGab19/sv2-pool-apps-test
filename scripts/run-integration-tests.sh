#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INTEGRATION_DIR="$REPO_ROOT/../sv2-integration-test-framework"

echo "🧪 Running integration tests for sv2-pool-apps-test changes..."
echo "📁 Repository root: $REPO_ROOT"
echo "📁 Integration test dir: $INTEGRATION_DIR"

# Clone/update integration test framework
if [ ! -d "$INTEGRATION_DIR" ]; then
    echo "📥 Cloning integration test framework..."
    cd "$(dirname "$INTEGRATION_DIR")"
    git clone https://github.com/GitGab19/sv2-integration-test-framework.git
else
    echo "🔄 Updating integration test framework..."
    cd "$INTEGRATION_DIR"
    git fetch origin
    git reset --hard origin/main
fi

cd "$INTEGRATION_DIR"

# Backup original Cargo.toml
cp Cargo.toml Cargo.toml.backup

# Update sv2-pool-apps-test dependency to use local path
echo "🔧 Updating dependency to use local sv2-pool-apps-test..."

# Use sed to replace git dependency with local path dependency
sed -i.bak 's|sv2-pool-apps-test = { git = "https://github.com/GitGab19/sv2-pool-apps-test", branch = "main" }|sv2-pool-apps-test = { path = "../sv2-pool-apps-test" }|g' Cargo.toml

echo "✅ Updated Cargo.toml to use local dependencies"
echo "🏃 Running integration tests..."

# Run the integration tests
cargo test --verbose

echo "🧹 Cleaning up..."
# Restore original Cargo.toml
mv Cargo.toml.backup Cargo.toml

echo "✅ Integration tests completed!"
