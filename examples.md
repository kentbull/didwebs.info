# Examples

Practical examples of using `did:webs`.

## Basic Examples

### Simple DID

A basic `did:webs` DID with no path:

```
did:webs:example.com:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
```

**Resolves to:**
- `https://example.com/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json`
- `https://example.com/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/keri.cesr`

### DID with Path

A `did:webs` DID with a path component:

```
did:webs:example.com:users:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
```

**Resolves to:**
- `https://example.com/users/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json`
- `https://example.com/users/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/keri.cesr`

### DID with Port

A `did:webs` DID with a non-standard port (note the `%3A` encoding):

```
did:webs:example.com%3A3000:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
```

**Resolves to:**
- `https://example.com:3000/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json`
- `https://example.com:3000/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/keri.cesr`

## Real-World Examples

### GLEIF Testnet Example 1

```
did:webs:hook.testnet.gleif.org%3A7702:dws:EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye
```

**Try it:**
- [Universal Resolver](https://dev.uniresolver.io/)
- [GLEIF Resolver](https://hook.testnet.gleif.org:7703/1.0/identifiers/did:webs:hook.testnet.gleif.org%3A7702:dws:EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye)
- [DID Document](https://hook.testnet.gleif.org:7702/dws/EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye/did.json)
- [KERI Stream](https://hook.testnet.gleif.org:7702/dws/EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye/keri.cesr)

### GLEIF Testnet Example 2

```
did:webs:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr
```

**Try it:**
- [Universal Resolver](https://dev.uniresolver.io/)
- [GLEIF Resolver](https://hook.testnet.gleif.org:7703/1.0/identifiers/did:webs:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr)
- [DID Document](https://hook.testnet.gleif.org:7702/dws/ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr/did.json)
- [KERI Stream](https://hook.testnet.gleif.org:7702/dws/ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr/keri.cesr)

## DID Document Examples

### Basic DID Document

```json
{
  "id": "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
  "verificationMethod": [
    {
      "id": "#DMJqIvb-YCWj7Ad2Hjq8wm0CgZcXTBcQ1Z-PaJtbv6ji",
      "type": "JsonWebKey",
      "controller": "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
      "publicKeyJwk": {
        "kid": "DMJqIvb-YCWj7Ad2Hjq8wm0CgZcXTBcQ1Z-PaJtbv6ji",
        "kty": "OKP",
        "crv": "Ed25519",
        "x": "wmoi9v5gJaPsB3YeOrzCbQKBlxdMFxDVn49om1u_qOI"
      }
    }
  ],
  "service": [
    {
      "id": "#BBilc4-L3tFUnfM_wJr4S4OJanAv_VmF_dJNN6vkf2Ha/witness",
      "type": "witness",
      "serviceEndpoint": {
        "http": "http://witness.example.com:5642/",
        "tcp": "tcp://witness.example.com:5632/"
      }
    }
  ],
  "alsoKnownAs": []
}
```

### DID Document with Designated Aliases

```json
{
  "id": "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
  "verificationMethod": [
    {
      "id": "#DMJqIvb-YCWj7Ad2Hjq8wm0CgZcXTBcQ1Z-PaJtbv6ji",
      "type": "JsonWebKey",
      "controller": "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
      "publicKeyJwk": {
        "kid": "DMJqIvb-YCWj7Ad2Hjq8wm0CgZcXTBcQ1Z-PaJtbv6ji",
        "kty": "OKP",
        "crv": "Ed25519",
        "x": "wmoi9v5gJaPsB3YeOrzCbQKBlxdMFxDVn49om1u_qOI"
      }
    }
  ],
  "service": [
    {
      "id": "#BBilc4-L3tFUnfM_wJr4S4OJanAv_VmF_dJNN6vkf2Ha/witness",
      "type": "witness",
      "serviceEndpoint": {
        "http": "http://witness.example.com:5642/",
        "tcp": "tcp://witness.example.com:5632/"
      }
    }
  ],
  "alsoKnownAs": [
    "did:web:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
    "did:webs:backup.example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
    "did:keri:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP"
  ]
}
```

## KERI Event Stream Examples

### Inception Event

The first event in a KERI event stream:

```json
{
  "v": "KERI10JSON000159_",
  "t": "icp",
  "d": "EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
  "i": "EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
  "s": "0",
  "kt": "1",
  "k": ["DMJqIvb-YCWj7Ad2Hjq8wm0CgZcXTBcQ1Z-PaJtbv6ji"],
  "nt": "1",
  "n": ["EHUtdHSj8FhR9amkKwz1PQBzgdsQe52NKqynxdXVZuyQ"],
  "bt": "1",
  "b": ["BBilc4-L3tFUnfM_wJr4S4OJanAv_VmF_dJNN6vkf2Ha"],
  "c": [],
  "a": []
}
```

**Fields:**
- `v`: Version string
- `t`: Event type (icp = inception)
- `d`: Event digest (self-addressing)
- `i`: Identifier (AID)
- `s`: Sequence number (0 for inception)
- `kt`: Key threshold (1 = single sig)
- `k`: Current public keys
- `nt`: Next key threshold
- `n`: Next key digests (pre-rotation)
- `bt`: Witness threshold
- `b`: Witness identifiers
- `c`: Configuration traits
- `a`: Anchors

### Rotation Event

A key rotation event:

```json
{
  "v": "KERI10JSON00013a_",
  "t": "rot",
  "d": "EPrcZNm-qeuxdjogRGLJJcGEBTUuy-jfJPTAzZhxdKHf",
  "i": "EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
  "s": "1",
  "p": "EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
  "kt": "1",
  "k": ["DNewPublicKey123456789012345678901234567890"],
  "nt": "1",
  "n": ["ENextKeyDigest123456789012345678901234567890"],
  "bt": "1",
  "br": [],
  "ba": [],
  "a": []
}
```

**New fields:**
- `p`: Previous event digest
- `br`: Witness cuts (removed witnesses)
- `ba`: Witness adds (new witnesses)

### Interaction Event

A non-establishment event (doesn't change keys):

```json
{
  "v": "KERI10JSON00013a_",
  "t": "ixn",
  "d": "EIK6DjeFUfvFc9jSlzayTS9S6RKb6EIArZQWD3PKc_pK",
  "i": "EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
  "s": "2",
  "p": "EPrcZNm-qeuxdjogRGLJJcGEBTUuy-jfJPTAzZhxdKHf",
  "a": [
    {
      "i": "EPxvM9FEbFq-wyKtWzNZfUig7v6lH4M6n3ebKRoyldlt",
      "s": "0",
      "d": "EHMHbxs6-9ln3zntcM4JOulKCHDdqAtdEOtw0qloErOZ"
    }
  ]
}
```

**Purpose:**
- Anchor external data (credentials, etc.)
- Update non-key-state information
- Maintain sequence continuity

## Command-Line Examples

### Generate did:webs Artifacts

```bash
dws did webs generate \
  --name my-keystore \
  --output-dir /path/to/output \
  --did "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP" \
  --verbose
```

### Resolve a did:webs DID

```bash
dws did webs resolve \
  --name my-keystore \
  --did "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP" \
  --verbose
```

### Start a Resolver Service

```bash
dws did webs resolver-service \
  --name my-keystore \
  --config-dir ./config \
  --static-files-dir /path/to/files \
  --port 7703
```

### Resolve via HTTP

```bash
curl -X GET "http://localhost:7703/1.0/identifiers/did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP"
```

## Use Case Examples

### Organizational Identity

An organization publishes its DID:

```
did:webs:acme.com:org:EOrganizationAID123456789012345678901234
```

**Use cases:**
- Issue verifiable credentials to employees
- Sign documents as the organization
- Establish trust with partners
- Manage organizational keys

### Personal Identity

An individual creates a portable identity:

```
did:webs:myidentity.com:alice:EAliceAID123456789012345678901234567890
```

**Use cases:**
- Receive verifiable credentials
- Authenticate to services
- Sign personal documents
- Control personal data

### IoT Device

A device manufacturer creates DIDs for devices:

```
did:webs:devices.manufacturer.com:sensors:ESensorAID123456789012
```

**Use cases:**
- Device authentication
- Firmware signing
- Telemetry verification
- Device lifecycle management

### Supply Chain

Supply chain participants track goods:

```
did:webs:supply.example.com:shipments:EShipmentAID12345678901
```

**Use cases:**
- Provenance tracking
- Custody chain verification
- Quality attestations
- Regulatory compliance

## Integration Examples

### With Verifiable Credentials

Issue a credential using a `did:webs` issuer:

```json
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1"
  ],
  "type": ["VerifiableCredential", "EmployeeCredential"],
  "issuer": "did:webs:acme.com:org:EOrganizationAID123456789012345678901234",
  "issuanceDate": "2024-01-01T00:00:00Z",
  "credentialSubject": {
    "id": "did:webs:myidentity.com:alice:EAliceAID123456789012345678901234567890",
    "employeeId": "12345",
    "role": "Engineer"
  },
  "proof": {
    "type": "Ed25519Signature2020",
    "created": "2024-01-01T00:00:00Z",
    "verificationMethod": "did:webs:acme.com:org:EOrganizationAID123456789012345678901234#key-1",
    "proofPurpose": "assertionMethod",
    "proofValue": "z..."
  }
}
```

### With DIDComm

Use `did:webs` for DIDComm messaging:

```json
{
  "@type": "https://didcomm.org/basicmessage/2.0/message",
  "id": "123456789",
  "from": "did:webs:alice.com:EAliceAID123456789012345678901234567890",
  "to": ["did:webs:bob.com:EBobAID123456789012345678901234567890"],
  "created_time": 1234567890,
  "body": {
    "content": "Hello Bob!"
  }
}
```

## Testing Examples

### Test DID Format

```python
import re

def is_valid_did_webs(did: str) -> bool:
    """Check if a string is a valid did:webs DID."""
    pattern = r'^did:webs:[a-zA-Z0-9.-]+(%3[Aa][0-9]+)?(:[a-zA-Z0-9._~-]+)*:[A-Za-z0-9+/=]+$'
    return bool(re.match(pattern, did))

# Test
assert is_valid_did_webs("did:webs:example.com:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP")
assert is_valid_did_webs("did:webs:example.com%3A3000:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP")
assert not is_valid_did_webs("did:web:example.com")
```

### Test DID-to-HTTPS Transformation

```python
def did_to_https(did: str) -> tuple[str, str]:
    """Transform a did:webs DID to HTTPS URLs."""
    # Remove did:webs: prefix
    path = did[9:]
    
    # Decode port separator
    path = path.replace('%3A', ':').replace('%3a', ':')
    
    # Replace colons with slashes
    parts = path.split(':')
    base_url = 'https://' + '/'.join(parts)
    
    return (
        f"{base_url}/did.json",
        f"{base_url}/keri.cesr"
    )

# Test
did = "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP"
did_doc_url, keri_url = did_to_https(did)

assert did_doc_url == "https://example.com/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json"
assert keri_url == "https://example.com/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/keri.cesr"
```

## More Examples

For more examples, see:

- [Quick Start Guide](quickstart.md) - Step-by-step tutorials
- [Implementation Guide](implementation/getting-started.md) - Developer examples
- [Deployments](deployments.md) - Live examples
- [Reference Implementation](https://github.com/GLEIF-IT/did-webs-resolver) - Code examples
