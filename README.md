# Introduction to did:webs

> **did:webs** - Web-based DIDs with KERI Security

The `did:webs` DID Method (`did:web` + Secure) was developed to enable greater trust and security than `did:web` without compromising the simplicity and discoverability of web-based DIDs. 

## What is did:webs?

`did:webs` is a [DID Method](https://www.w3.org/TR/did-core/#methods) that combines the ease of use and discoverability of `did:web` with the cryptographic security of [KERI](https://keri.one) (Key Event Receipt Infrastructure).

Like `did:web`, the `did:webs` method uses traditional web infrastructure to publish DIDs and make them discoverable. Unlike `did:web`, this method's trust is **not** rooted in DNS, webmasters, X.509, and certificate authorities. Instead, it uses KERI to provide a secure chain of cryptographic key events by those who control the identifier.

## Core Features

The `did:webs` method provides several key features that complement `did:web`:

- **DID-to-HTTPS transformation** - Uses the same simple transformation as `did:web`
- **Verifiable History** - Complete cryptographic chain of key events from inception to present
- **Self-Certifying Identifiers (SCIDs)** - Globally unique identifiers derived from inception events
- **Authorized Keys** - All DID document updates contain proofs signed by authorized controllers
- **Pre-rotation Keys** (optional) - Prevents loss of control if active keys are compromised
- **Witnesses** (optional) - Collaborative approval of updates before publication
- **DID Portability** (optional) - Move DIDs between web locations while preserving history
- **End-Verifiable Data** - Trust derives from cryptography, not web infrastructure

## How It Works

A `did:webs` identifier looks like this:

```
did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
```

This DID resolves to two files on the web:

1. **`did.json`** - The DID document (same as `did:web`)
2. **`keri.cesr`** - The KERI event stream that proves the DID document's authenticity

The transformation is simple:
- `did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP`
- → `https://example.com/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json`
- → `https://example.com/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/keri.cesr`

## Why did:webs?

### The Problem with did:web

While `did:web` is wonderfully simple and familiar to developers, it has security limitations:

- Trust depends on DNS, TLS certificates, and certificate authorities
- Websites can be hacked or compromised
- DNS can be hijacked
- No cryptographic proof of key history
- Centralized trust in web infrastructure

### The did:webs Solution

`did:webs` separates **publication** from **trust**:

- **Publication**: Still uses familiar web infrastructure (like `did:web`)
- **Trust**: Derives from KERI's cryptographic key event logs

This preserves the convenience of `did:web` while drastically upgrading security through authentic, end-verifiable data.

## Key Benefits

✅ **Easy to Implement** - No exotic cryptography or blockchain required  
✅ **Scalable** - Uses standard web infrastructure  
✅ **Secure** - Cryptographic proof of key history and updates  
✅ **Portable** - DIDs can move between web locations  
✅ **Interoperable** - Compatible with `did:web` and Universal Resolver  
✅ **Decentralized Trust** - No dependence on certificate authorities  
✅ **Regulatory Friendly** - No blockchain concerns  

## Trade-offs

Like all DID methods, `did:webs` makes trade-offs:

**Pros:**
- Cheap and easy to deploy
- No blockchain required
- Strong cryptographic security
- Transparent governance
- Scalable through delegation

**Cons:**
- Depends on web for publication and discovery
- Requires learning KERI concepts
- Higher bar of accountability for users

## Getting Started

Ready to dive in? Check out:

- [Quick Start Guide](quickstart.md) - Get up and running quickly
- [Specification](specification.md) - Read the full technical specification
- [Implementer's Guide](implementation/getting-started.md) - Build with did:webs
- [Deployments](deployments.md) - Try live did:webs resolvers

## Example

Here's a real working example from the GLEIF testnet:

```
did:webs:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr
```

You can resolve this DID at:
- [Universal Resolver](https://dev.uniresolver.io/)
- [GLEIF Testnet](https://hook.testnet.gleif.org:7703/1.0/identifiers/did:webs:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr)

## Learn More

- **Specification Repository**: [tswg-did-method-webs-specification](https://github.com/trustoverip/tswg-did-method-webs-specification)
- **Reference Implementation**: [did-webs-resolver](https://github.com/GLEIF-IT/did-webs-resolver)
- **KERI**: [keri.one](https://keri.one)
- **Trust Over IP**: [trustoverip.org](https://trustoverip.org)
