# Implementations

Current implementations of the `did:webs` DID method.

## Reference Implementation

### did-webs-resolver

The primary reference implementation for `did:webs`, maintained by GLEIF.

- **Repository**: [https://github.com/GLEIF-IT/did-webs-resolver](https://github.com/GLEIF-IT/did-webs-resolver)
- **Language**: Python
- **License**: Apache 2.0
- **Status**: Active development
- **CI/CD**: [![CI](https://github.com/GLEIF-IT/did-webs-resolver/actions/workflows/ci.yml/badge.svg)](https://github.com/GLEIF-IT/did-webs-resolver/actions/workflows/ci.yml)
- **Code Coverage**: [![codecov](https://codecov.io/gh/GLEIF-IT/did-webs-resolver/branch/main/graph/badge.svg?token=sUADtbanWC)](https://codecov.io/gh/GLEIF-IT/did-webs-resolver)

### Features

The reference implementation includes:

#### 1. Static Artifact Generator
Generates `did.json` and `keri.cesr` files for `did:webs` DIDs from KERI AIDs.

```bash
dws did webs generate \
  --name my-keystore \
  --output-dir /path/to/output \
  --did "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP"
```

#### 2. Static Server Mode
Serves static `did.json` and `keri.cesr` files from a local directory.

```bash
dws did webs service \
  --name my-keystore \
  --static-files-dir /path/to/files
```

#### 3. Dynamic Artifact Resolver
Dynamically generates `did.json` and `keri.cesr` files upon receiving HTTP requests.

```bash
dws did webs service \
  --name my-keystore \
  --dynamic
```

#### 4. Universal Resolver Service
Supports the DIF Universal Resolver API at `/1.0/identifiers/{did}` for both `did:webs` and `did:keri` resolution.

```bash
dws did webs resolver-service \
  --name my-keystore \
  --config-dir ./config \
  --static-files-dir /path/to/files
```

#### 5. Resolution Commands
Command-line tools for resolving DIDs:

```bash
# Resolve did:webs
dws did webs resolve \
  --name my-keystore \
  --did "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP"

# Resolve did:keri
dws did keri resolve \
  --name my-keystore \
  --did "did:keri:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP" \
  --oobi "http://witness:5642/oobi/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP"
```

### Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   did-webs-resolver                     │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────┐  ┌─────────────────┐             │
│  │  CLI Commands   │  │  HTTP Services  │             │
│  │  - generate     │  │  - static       │             │
│  │  - resolve      │  │  - dynamic      │             │
│  │  - service      │  │  - resolver API │             │
│  └────────┬────────┘  └────────┬────────┘             │
│           │                     │                       │
│           └──────────┬──────────┘                       │
│                      │                                  │
│           ┌──────────▼──────────┐                       │
│           │   Core Libraries    │                       │
│           │  - artifacting      │                       │
│           │  - resolving        │                       │
│           │  - didding          │                       │
│           │  - webbing          │                       │
│           └──────────┬──────────┘                       │
│                      │                                  │
│           ┌──────────▼──────────┐                       │
│           │   KERIpy (KERI)     │                       │
│           │  - Key management   │                       │
│           │  - Event logs       │                       │
│           │  - Witnesses        │                       │
│           └─────────────────────┘                       │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Dependencies

- **KERIpy**: KERI protocol implementation
- **Hio**: Async I/O framework
- **Falcon**: Web framework for HTTP services
- **uv**: Fast Python package manager

### Installation

**Using uv (recommended):**

```bash
git clone https://github.com/GLEIF-IT/did-webs-resolver.git
cd did-webs-resolver
uv lock
uv sync
source .venv/bin/activate
```

**Using Docker:**

```bash
docker compose build
docker compose up -d
```

### Testing

The implementation includes comprehensive tests:

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=src --cov-report=html

# Run specific test
pytest tests/dws/core/test_resolving.py
```

### Documentation

- [Getting Started Guide](implementation/getting-started.md)
- [Commands Reference](implementation/commands.md)
- [API Documentation](https://github.com/GLEIF-IT/did-webs-resolver/tree/main/docs)
- [Troubleshooting](https://github.com/GLEIF-IT/did-webs-resolver/blob/main/docs/troubleshooting.md)

---

## Prior Art

The `did:webs` implementation builds on previous work:

### did:keri Resolver

Original KERI-based DID resolver by Philip Feairheller.

- **Repository**: [https://github.com/WebOfTrust/did-keri-resolver](https://github.com/WebOfTrust/did-keri-resolver)
- **Influence**: Foundation for KERI integration in `did:webs`

### IIW37 Tutorial

Original `did:webs` tutorial by Markus Sabadello from DanubeTech.

- **Repository**: [https://github.com/peacekeeper/did-webs-iiw-tutorial](https://github.com/peacekeeper/did-webs-iiw-tutorial)
- **Influence**: Initial proof of concept and tutorial materials

---

## Universal Resolver Driver

The `did:webs` method is integrated into the Universal Resolver.

- **Repository**: [https://github.com/decentralized-identity/universal-resolver](https://github.com/decentralized-identity/universal-resolver)
- **Driver**: `did-webs` driver
- **Deployment**: [https://dev.uniresolver.io/](https://dev.uniresolver.io/)

---

## Related Projects

### KERIpy

Core KERI protocol implementation in Python.

- **Repository**: [https://github.com/WebOfTrust/keripy](https://github.com/WebOfTrust/keripy)
- **Purpose**: KERI protocol implementation
- **Used by**: did-webs-resolver

### Signify

KERI signing and verification library.

- **Repository**: [https://github.com/WebOfTrust/signify-ts](https://github.com/WebOfTrust/signify-ts) (TypeScript)
- **Repository**: [https://github.com/WebOfTrust/signifypy](https://github.com/WebOfTrust/signifypy) (Python)
- **Purpose**: Client library for KERI operations

### KERIA

KERI Agent service for managing identifiers.

- **Repository**: [https://github.com/WebOfTrust/keria](https://github.com/WebOfTrust/keria)
- **Purpose**: KERI agent with REST API
- **Integration**: Can be used with did-webs-resolver

---

## Implementation Status

### Specification Compliance

The reference implementation (`did-webs-resolver`) implements:

- ✅ Core DID method specification
- ✅ DID document generation from KERI AIDs
- ✅ KERI event stream verification
- ✅ DID-to-HTTPS transformation
- ✅ Universal Resolver API compatibility
- ✅ Static and dynamic artifact serving
- ✅ Witness network support
- ✅ Designated aliases (alsoKnownAs)
- ✅ Pre-rotation key support
- ✅ Delegated identifiers
- 🚧 DID portability (in progress)
- 🚧 High assurance DIDs with DNS (planned)

### Known Limitations

- Some tests in `test_habs.py` and `test_clienting.py` are flaky and may require re-running
- Mocking could be improved in certain test scenarios
- Documentation for advanced features is still being developed

---

## Contributing

Want to contribute to `did:webs` implementations?

### Reference Implementation

1. Fork the repository: [https://github.com/GLEIF-IT/did-webs-resolver](https://github.com/GLEIF-IT/did-webs-resolver)
2. Create a feature branch
3. Make your changes with tests
4. Submit a pull request

### Specification

1. Fork the specification: [https://github.com/trustoverip/tswg-did-method-webs-specification](https://github.com/trustoverip/tswg-did-method-webs-specification)
2. Review the [Contributing Guide](contributing.md)
3. Submit issues or pull requests

### New Implementations

Planning a new implementation in another language?

- Review the [specification](specification.md)
- Check the [implementer's guide](implementation/getting-started.md)
- Use the reference implementation as a guide
- Test against the GLEIF testnet
- Share your implementation with the community!

---

## Community

- **GitHub**: [WebOfTrust](https://github.com/WebOfTrust)
- **Specification**: [Trust Over IP Foundation](https://github.com/trustoverip)
- **GLEIF**: [Global Legal Entity Identifier Foundation](https://www.gleif.org/)
- **KERI**: [keri.one](https://keri.one)

---

## License

The reference implementation is licensed under the Apache 2.0 License.

The specification is developed under the Trust Over IP Foundation's governance.
