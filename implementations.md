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


### Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   did-webs-resolver                     │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────┐  ┌─────────────────┐               │
│  │  CLI Commands   │  │  HTTP Services  │               │
│  │  - generate     │  │  - static       │               │
│  │  - resolve      │  │  - dynamic      │               │
│  │  - service      │  │  - resolver API │               │
│  └────────┬────────┘  └────────┬────────┘               │
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


## Community

- **GitHub**: [WebOfTrust](https://github.com/WebOfTrust)
- **Specification**: [Trust Over IP Foundation](https://github.com/trustoverip)
- **GLEIF**: [Global Legal Entity Identifier Foundation](https://www.gleif.org/)
- **KERI**: [keri.one](https://keri.one)

---

## License

The reference implementation is licensed under the Apache 2.0 License.
