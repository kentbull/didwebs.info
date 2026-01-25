# Overview

## What Makes did:webs Different?

The `did:webs` DID method addresses a fundamental challenge in decentralized identity: how to make DIDs both **easy to use** and **cryptographically secure**.

### Two Questions, Two Answers

DID methods must answer two critical questions:

1. **How is information about DIDs published and discovered?**
2. **How is the trustworthiness of this information evaluated?**

The `did:web` method merges these questions, giving one answer: *Information is published and secured using familiar web mechanisms*. This has wonderful adoption benefits because the processes and tooling are familiar to millions of developers.

Unfortunately, this answer works better for the first question than the second. The current web is simply not very trustworthy:

- Websites get hacked
- Sysadmins can be malicious
- DNS can be hijacked
- X.509 certificates often prove less than clients wish
- Browser validation checks are imperfect
- Certificate authorities have varying quality standards
- TLS is susceptible to man-in-the-middle attacks

### The did:webs Approach

The `did:webs` method **separates these two questions** and answers them distinctively:

- **Information about DIDs** is still published on the web (like `did:web`)
- **Trustworthiness** derives from mechanisms entirely governed by individual DID controllers (using KERI)

This preserves most of the delightful convenience of `did:web`, while drastically upgrading security through authentic data that is end-verifiable.

## Architecture

### Components

A `did:webs` system consists of:

1. **DID Document** (`did.json`) - Standard W3C DID document
2. **KERI Event Stream** (`keri.cesr`) - Cryptographic proof chain
3. **Web Server** - Standard HTTPS server for publication
4. **Resolver** - Software that verifies the KERI event stream

### Data Flow

```
┌─────────────┐
│   Creator   │
│  (AID Owner)│
└──────┬──────┘
       │
       │ 1. Create KERI AID
       │ 2. Generate did.json & keri.cesr
       │
       ▼
┌─────────────┐
│ Web Server  │
│  (HTTPS)    │
└──────┬──────┘
       │
       │ 3. Publish files
       │
       ▼
┌─────────────┐
│  Resolver   │
│  (Verifier) │
└──────┬──────┘
       │
       │ 4. Fetch files
       │ 5. Verify KERI chain
       │ 6. Return DID document
       │
       ▼
┌─────────────┐
│    User     │
│ (Verifier)  │
└─────────────┘
```

## KERI Integration

### What is KERI?

KERI (Key Event Receipt Infrastructure) is a protocol for managing cryptographic keys with a verifiable history. It provides:

- **Self-Certifying Identifiers** - Identifiers derived from cryptographic keys
- **Key Event Logs** - Immutable history of all key operations
- **Pre-Rotation** - Protection against key compromise
- **Witnesses, Watchers, and Observers** - Scalable verification and consensus without blockchain
- **Delegated Identifiers** - Hierarchical key management

### How did:webs Uses KERI

`did:webs` uses KERI to:

1. **Generate the AID** - The final component of the DID is a KERI AID
2. **Prove Key History** - The `keri.cesr` file contains the complete key event log
3. **Verify Updates** - All designated alias or other DID document changes must be verifiable by current keys
4. **Detect Tampering** - Any modification to the event log is cryptographically detectable
5. **Enable Portability** - The same AID can be used across different web locations

### The keri.cesr File

The KERI event stream is a CESR (Composable Event Streaming Representation) formatted file containing:

- **Inception Event** - The birth of the identifier
- **Rotation Events** - Key rotation operations
- **Interaction Events** - Non-key-state changes (like anchoring credentials)
- **Receipts** - Witness signatures proving publication
- **Delegations** - If the identifier is delegated

Example structure:

```json
{"v":"KERI10JSON000159_","t":"icp","d":"ED1e8pD24aqd...","i":"ED1e8pD24aqd...","s":"0",...}
-VA--AABAA...
{"v":"KERI10JSON00013a_","t":"rot","d":"EPrcZNm-qeux...","i":"ED1e8pD24aqd...","s":"1",...}
-VA--AABAA...
```

## Comparison with Other DID Methods

### did:webs vs did:web

| Feature                       | did:web  | did:webs         |
|-------------------------------|----------|------------------|
| Web-based publication         | ✅        | ✅                |
| Simple HTTPS transformation   | ✅        | ✅                |
| Cryptographic key history     | ❌        | ✅                |
| Verifiable updates            | ❌        | ✅                |
| Protection against compromise | ❌        | ✅ (pre-rotation) |
| DID portability               | ❌        | ✅                |
| Trust in web infrastructure   | Required | Not required     |
| Additional file required      | None     | keri.cesr        |

### did:webs vs Blockchain DIDs

| Feature                   | Blockchain DIDs | did:webs      |
|---------------------------|-----------------|---------------|
| Decentralized trust       | ✅               | ✅             |
| Cryptographic security    | ✅               | ✅             |
| Transaction costs         | ❌ (fees)        | ✅ (free)      |
| Speed                     | ❌ (slow)        | ✅ (fast)      |
| Regulatory concerns       | ❌ (varies)      | ✅ (minimal)   |
| Scalability               | ❌ (limited)     | ✅ (web-scale) |
| Infrastructure complexity | ❌ (high)        | ✅ (low)       |

## Use Cases

### Organizational Identities

Organizations can use `did:webs` to:
- Publish verifiable organizational identifiers
- Manage key rotation without downtime
- Delegate authority to departments or subsidiaries
- Maintain cryptographic proof of all key operations

### Personal Identities

Individuals can use `did:webs` to:
- Create portable digital identities
- Control their own keys without blockchain
- Move identities between service providers
- Maintain privacy while proving authenticity

### IoT and Edge Devices

While `did:webs` depends on the web for publication, it builds on KERI which fully supports:
- IoT environments
- Low-power devices (LoRa, Bluetooth, NFC)
- Offline-first scenarios
- Future interoperability with non-web environments

### Supply Chain

Supply chain participants can use `did:webs` to:
- Track provenance with verifiable identifiers
- Manage complex delegation hierarchies
- Prove authenticity without blockchain costs
- Integrate with existing web infrastructure

## Security Model

### Threat Model

`did:webs` protects against:

- ✅ **Key compromise** - Pre-rotation prevents unauthorized key changes
- ✅ **DNS hijacking** - KERI verification detects tampering
- ✅ **Man-in-the-middle** - Cryptographic signatures prove authenticity
- ✅ **Malicious webmasters** - Cannot forge valid KERI events
- ✅ **Replay attacks** - Sequence numbers prevent reuse
- ✅ **Fork attacks** - Witnesses detect duplicity

### Trust Assumptions

`did:webs` assumes:

- Users can access the web to fetch DID documents
- KERI cryptography is sound (Ed25519, etc.)
- Witnesses, watchers, and observers (if used) are not all compromised
- Users verify the KERI event stream (not just the DID document)

### Privacy Considerations

- **Publication**: DIDs are public by design
- **Correlation**: Same AID across locations is intentionally correlatable
- **Metadata**: Web server logs may reveal access patterns

## Next Steps

- **Try it**: Check out the [Quick Start](quickstart.md) guide
- **Build it**: Read the [Implementer's Guide](implementation/getting-started.md)
- **Understand it**: Dive into the [Specification](specification.md)
- **Deploy it**: See [Deployments](deployments.md) for live examples
