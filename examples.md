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
did:webs:hook.testnet.gleif.org%3A7701:dws:EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye
```

**Try it:**
- [Universal Resolver](https://dev.uniresolver.io/)
- [GLEIF Resolver](https://hook.testnet.gleif.org:7703/1.0/identifiers/did:webs:hook.testnet.gleif.org%3A7701:dws:EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye)
- [DID Document](https://hook.testnet.gleif.org:7701/dws/EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye/did.json)
- [KERI Stream](https://hook.testnet.gleif.org:7701/dws/EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye/keri.cesr)

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

## More Examples

For more examples, see:

- [Quick Start Guide](quickstart.md) - Step-by-step tutorials
- [Implementation Guide](implementation/getting-started.md) - Developer examples
- [Deployments](deployments.md) - Live examples
- [Reference Implementation](https://github.com/GLEIF-IT/did-webs-resolver) - Code examples
