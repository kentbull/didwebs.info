# Deployments

Live `did:webs` deployments you can use for testing and development.

## Universal Resolver

The [Universal Resolver](https://dev.uniresolver.io/) is a community-maintained DID resolution service that supports multiple DID methods, including `did:webs`.

- **URL**: [https://dev.uniresolver.io/](https://dev.uniresolver.io/)
- **API Endpoint**: `https://dev.uniresolver.io/1.0/identifiers/{did}`
- **Status**: Production
- **Maintained by**: Decentralized Identity Foundation (DIF)

### Usage

**Web Interface:**

1. Visit [https://dev.uniresolver.io/](https://dev.uniresolver.io/)
2. Enter a `did:webs` DID in the input field
3. Click "Resolve"
4. View the resolved DID document

**API:**

```bash
curl -X GET "https://dev.uniresolver.io/1.0/identifiers/did:webs:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr"
```

**Response:**

```json
{
  "didDocument": {
    "id": "did:webs:hook.testnet.gleif.org:7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
    "verificationMethod": [...],
    "service": [...],
    "alsoKnownAs": [...]
  },
  "didResolutionMetadata": {
    "contentType": "application/did+ld+json"
  },
  "didDocumentMetadata": {}
}
```

### Features

- ✅ Supports `did:webs` resolution
- ✅ Verifies KERI event streams
- ✅ Returns standard DID resolution response
- ✅ RESTful API
- ✅ Web interface for testing

---

## GLEIF Testnet

The Global Legal Entity Identifier Foundation (GLEIF) operates a `did:webs` testnet for development and testing.

- **URL**: [https://hook.testnet.gleif.org:7703/](https://hook.testnet.gleif.org:7703/)
- **API Endpoint**: `https://hook.testnet.gleif.org:7703/1.0/identifiers/{did}`
- **Status**: Testnet (for development and testing)
- **Maintained by**: GLEIF

### Usage

**Direct Resolution:**

```bash
curl -X GET "https://hook.testnet.gleif.org:7703/1.0/identifiers/did:webs:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr"
```

**Fetch DID Document Directly:**

```bash
curl https://hook.testnet.gleif.org:7702/dws/ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr/did.json
```

**Fetch KERI Event Stream:**

```bash
curl https://hook.testnet.gleif.org:7702/dws/ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr/keri.cesr
```

### Test DIDs

Try these working `did:webs` DIDs on the GLEIF testnet:

**Example 1:**
```
did:webs:hook.testnet.gleif.org%3A7701:dws:EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye
```

- **DID Document**: [https://hook.testnet.gleif.org:7701/dws/EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye/did.json](https://hook.testnet.gleif.org:7701/dws/EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye/did.json)
- **KERI Stream**: [https://hook.testnet.gleif.org:7701/dws/EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye/keri.cesr](https://hook.testnet.gleif.org:7701/dws/EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye/keri.cesr)
- **Resolver**: [https://hook.testnet.gleif.org:7703/1.0/identifiers/did:webs:hook.testnet.gleif.org%3A7701:dws:EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye](https://hook.testnet.gleif.org:7703/1.0/identifiers/did:webs:hook.testnet.gleif.org%3A7701:dws:EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye)

**Example 2:**
```
did:webs:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr
```

- **DID Document**: [https://hook.testnet.gleif.org:7702/dws/ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr/did.json](https://hook.testnet.gleif.org:7702/dws/ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr/did.json)
- **KERI Stream**: [https://hook.testnet.gleif.org:7702/dws/ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr/keri.cesr](https://hook.testnet.gleif.org:7702/dws/ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr/keri.cesr)
- **Resolver**: [https://hook.testnet.gleif.org:7703/1.0/identifiers/did:webs:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr](https://hook.testnet.gleif.org:7703/1.0/identifiers/did:webs:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr)

### Features

- ✅ Full `did:webs` resolver implementation
- ✅ KERI event stream verification
- ✅ Witness network support
- ✅ Designated aliases support
- ✅ Compatible with Universal Resolver API
- ✅ Static and dynamic artifact serving

### Architecture

The GLEIF testnet deployment consists of:

1. **KERI Witness Network** - Distributed witnesses for event validation
2. **Static Web Server** - Serves `did.json` and `keri.cesr` files
3. **Resolver Service** - Universal Resolver-compatible API
4. **Controller Services** - For creating and managing DIDs

### Use Cases

The GLEIF testnet is ideal for:

- **Development**: Test your `did:webs` integration
- **Testing**: Validate resolution and verification logic
- **Demos**: Show `did:webs` in action
- **Learning**: Understand how `did:webs` works

---

## Running Your Own Deployment

Want to run your own `did:webs` resolver? See the [Implementation Guide](implementation/getting-started.md) for:

- Docker Compose setup
- Local development environment
- Production deployment considerations
- Witness network configuration

### Quick Deploy with Docker

```bash
git clone https://github.com/GLEIF-IT/did-webs-resolver.git
cd did-webs-resolver
docker compose up -d
```

This starts a complete `did:webs` environment including:
- KERI witness network
- Static web server
- Resolver service
- Shell container for CLI commands

---

## Comparison

| Feature | Universal Resolver | GLEIF Testnet |
|---------|-------------------|---------------|
| **Purpose** | Multi-method resolver | `did:webs` testnet |
| **Status** | Production | Testnet |
| **API** | Standard DIF API | Universal Resolver API |
| **Methods** | 50+ DID methods | `did:webs`, `did:keri` |
| **Witnesses** | N/A | Full witness network |
| **Hosting** | Community | GLEIF |
| **Use Case** | General resolution | Development/testing |

---

## Additional Resources

- **Reference Implementation**: [did-webs-resolver on GitHub](https://github.com/GLEIF-IT/did-webs-resolver)
- **Specification**: [tswg-did-method-webs-specification](https://github.com/trustoverip/tswg-did-method-webs-specification)
- **GLEIF**: [gleif.org](https://www.gleif.org/)
- **Universal Resolver**: [dev.uniresolver.io](https://dev.uniresolver.io/)
