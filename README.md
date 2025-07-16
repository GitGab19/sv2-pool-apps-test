# SV2 Pool Apps Test Repository

This is a test repository for SV2 pool applications.

## Contents

- `pool/` - SV2 Pool server implementation
- `jd-server/` - Job Declaration Server implementation  
- `roles-utils/` - Shared utilities for SV2 roles

## Dependencies

This repository depends on `sv2-core-test` for all protocol implementations.

## Local Integration Testing

To run integration tests locally:

```bash
./scripts/run-integration-tests.sh
```

This will:
1. Clone/update the integration test framework
2. Update dependencies to use your local changes
3. Run the full integration test suite
4. Restore the original configuration

## CI/CD

This repository automatically runs integration tests on every PR using the reusable workflow from the `sv2-integration-test-framework` repository.
