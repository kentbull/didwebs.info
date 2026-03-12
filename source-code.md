# Source Code

Links to all source code repositories for `did:webs`.

## Quick Links

- did:webs spec: [https://github.com/trustoverip/kswg-did-method-webs-specification](https://github.com/trustoverip/kswg-did-method-webs-specification)
- did:webs reference implementation: [https://github.com/GLEIF-IT/did-webs-resolver](https://github.com/GLEIF-IT/did-webs-resolver)

## Official Specification

### ToIP did:webs specification

The official `did:webs` DID Method specification developed by the Trust Over IP Foundation.

- **Organization**: Trust Over IP Foundation
- **Working Group**: KERI Stack Working Group (KSWG)
- **Task Force**: [DID WebS Method Task Force](https://lf-toip.atlassian.net/wiki/spaces/HOME/pages/22992904/DID+WebS+Method+Task+Force)
- **Status**: Draft
- **License**: [OWF Contributor License Agreement 1.0](https://www.openwebfoundation.org/the-agreements/the-owf-1-0-agreements-granted-claims/owf-contributor-license-agreement-1-0-copyright) for the spec, [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) for the implementation code

**Links:**
- 📖 **Specification**: [https://trustoverip.github.io/kswg-did-method-webs-specification/](https://trustoverip.github.io/kswg-did-method-webs-specification/)
- 📂 **Source Code**: [https://github.com/trustoverip/kswg-did-method-webs-specification](https://github.com/trustoverip/kswg-did-method-webs-specification)


**Contributing:**
- [Contributing Guide](https://github.com/trustoverip/kswg-did-method-webs-specification/blob/main/Contributing.md)
- [Editing the Spec](https://github.com/trustoverip/kswg-did-method-webs-specification/blob/main/EditingTheSpec.md)

---

## Reference Implementation

### did-webs-resolver

The primary reference implementation maintained by GLEIF (Global Legal Entity Identifier Foundation).

- **Organization**: GLEIF-IT
- **Language**: Python 3.10+
- **License**: Apache 2.0
- **Status**: Active development
- **Package**: `did-webs-resolver` (PyPI)

**Links:**
- 📂 **Source Code**: [https://github.com/GLEIF-IT/did-webs-resolver](https://github.com/GLEIF-IT/did-webs-resolver)
- 📦 **PyPI Package**: [https://pypi.org/project/did-webs-resolver/](https://pypi.org/project/did-webs-resolver/)
- 📝 **Issues**: [https://github.com/GLEIF-IT/did-webs-resolver/issues](https://github.com/GLEIF-IT/did-webs-resolver/issues)
- 🔀 **Pull Requests**: [https://github.com/GLEIF-IT/did-webs-resolver/pulls](https://github.com/GLEIF-IT/did-webs-resolver/pulls)

**Installation:**
```bash
# From PyPI
pip install did-webs-resolver

# From source
git clone https://github.com/GLEIF-IT/did-webs-resolver.git
cd did-webs-resolver
uv sync
source .venv/bin/activate
```

---

## This Documentation Site

### didwebs.info

This documentation site you're reading now!

- **Maintainer**: Kent Bull
- **Technology**: Docsify
- **License**: OWF Contributor License Agreement 1.0
- **Status**: Active

**Links:**
- 🌐 **Live Site**: [https://didwebs.info/](https://didwebs.info/)
- 📂 **Source Code**: [https://github.com/kentbull/didwebs.info](https://github.com/kentbull/didwebs.info)

**Technology Stack:**
- **Framework**: [Docsify](https://docsify.js.org/) - Client-side documentation
- **Hosting**: GitHub Pages with GitHub Actions CI/CD
- **Theme**: Vue theme with custom styling
- **Plugins**: Search, pagination, code copy, syntax highlighting

**Contributing:**
```bash
# Fork and clone
git clone git@github.com:YOUR_USERNAME/didwebs.info.git
cd didwebs.info

# Test locally
./serve.sh

# Make changes, commit, and submit PR
git checkout -b feature/my-update
git commit -m "Update documentation"
git push origin feature/my-update
```

---

## Related Repositories

### KERI Protocol

Core KERI protocol implementations that power `did:webs`:

#### KERIpy

Python implementation of KERI.

- **Repository**: [https://github.com/WebOfTrust/keripy](https://github.com/WebOfTrust/keripy)
- **Language**: Python
- **License**: Apache 2.0
- **CLI**: `kli` command

**Key for did:webs:**
- Provides KERI identifier management
- Witness, watcher, and observer network functionality
- Credential issuance (ACDC)
- Key rotation and delegation

#### Signify-TS

TypeScript KERI client library.

- **Repository**: [https://github.com/WebOfTrust/signify-ts](https://github.com/WebOfTrust/signify-ts)
- **Language**: TypeScript
- **License**: Apache 2.0

#### Signify-Py

Python KERI client library.

- **Repository**: [https://github.com/WebOfTrust/signifypy](https://github.com/WebOfTrust/signifypy)
- **Language**: Python
- **License**: Apache 2.0

### KERIA

KERI Agent service with REST API.

- **Repository**: [https://github.com/WebOfTrust/keria](https://github.com/WebOfTrust/keria)
- **Language**: Python
- **License**: Apache 2.0

Can be used to manage KERI identifiers that power `did:webs` DIDs.

### Universal Resolver

Multi-method DID resolver that includes `did:webs` support.

- **Repository**: [https://github.com/decentralized-identity/universal-resolver](https://github.com/decentralized-identity/universal-resolver)
- **License**: Apache 2.0
- **Live Demo**: [https://dev.uniresolver.io/](https://dev.uniresolver.io/)

---

## Specifications

Related specifications:

### KERI Specification

Key Event Receipt Infrastructure specification.

- **Specification**: [https://trustoverip.github.io/kswg-keri-specification/](https://trustoverip.github.io/kswg-keri-specification/)
- **Repository**: [https://github.com/trustoverip/kswg-keri-specification](https://github.com/trustoverip/kswg-keri-specification)

### CESR Specification

Composable Event Streaming Representation specification.

- **Specification**: [https://trustoverip.github.io/kswg-cesr-specification/](https://trustoverip.github.io/kswg-cesr-specification/)
- **Repository**: [https://github.com/trustoverip/kswg-cesr-specification](https://github.com/trustoverip/kswg-cesr-specification)

### ACDC Specification

Authentic Chained Data Containers specification (for credentials).

- **Specification**: [https://trustoverip.github.io/kswg-acdc-specification/](https://trustoverip.github.io/kswg-acdc-specification/)
- **Repository**: [https://github.com/trustoverip/kswg-acdc-specification](https://github.com/trustoverip/kswg-acdc-specification)

### did:web Specification

The simpler predecessor to `did:webs`.

- **Specification**: [https://w3c-ccg.github.io/did-method-web/](https://w3c-ccg.github.io/did-method-web/)
- **Repository**: [https://github.com/w3c-ccg/did-method-web](https://github.com/w3c-ccg/did-method-web)

---


**Contributions welcome.**
