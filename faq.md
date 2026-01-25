# Frequently Asked Questions

Common questions about `did:webs`.

## General Questions

### What is did:webs?

`did:webs` is a DID method that combines the simplicity of `did:web` with the security of KERI (Key Event Receipt Infrastructure). It uses standard web infrastructure for publication but derives trust from cryptographic key event logs rather than DNS and certificate authorities.

### How is did:webs different from did:web?

| Feature | did:web | did:webs |
|---------|---------|----------|
| Web-based | ✅ | ✅ |
| Simple HTTPS | ✅ | ✅ |
| Cryptographic history | ❌ | ✅ |
| Verifiable updates | ❌ | ✅ |
| Key compromise protection | ❌ | ✅ |
| Trust model | DNS/TLS/CAs | KERI |
| Additional files | None | keri.cesr |

### Why not just use did:web?

`did:web` is simple but has security limitations:
- Trust depends on DNS and certificate authorities
- No cryptographic proof of key history
- Vulnerable to DNS hijacking and website compromise
- No protection against key compromise

`did:webs` addresses these issues while maintaining web-based simplicity.

### Do I need a blockchain?

**No!** `did:webs` does not require any blockchain. It uses KERI for cryptographic security, which is blockchain-free. However, KERI can optionally reference blockchains as an additional publication mechanism if desired.

### Is did:webs decentralized?

Yes and no:
- **Trust**: Fully decentralized - derived from cryptography, not centralized authorities
- **Publication**: Uses web infrastructure, which may be centralized
- **Discovery**: Depends on DNS, which has centralized aspects

The key insight is that `did:webs` separates **publication** (web) from **trust** (KERI).

## Technical Questions

### What is KERI?

KERI (Key Event Receipt Infrastructure) is a protocol for managing cryptographic keys with a verifiable history. It provides:
- Self-certifying identifiers
- Immutable key event logs
- Pre-rotation for key compromise protection
- Witnesses for distributed consensus
- No blockchain required

Learn more at [keri.one](https://keri.one).

### What is an AID?

AID stands for Autonomic Identifier. It's a KERI identifier that is:
- Self-certifying (derived from cryptographic keys)
- Portable (can be used across different systems)
- Verifiable (has a complete key event history)

In `did:webs`, the AID is the final component of the DID.

### What is the keri.cesr file?

The `keri.cesr` file contains the KERI event stream in CESR (Composable Event Streaming Representation) format. It includes:
- Inception event (birth of the identifier)
- Rotation events (key changes)
- Interaction events (non-key-state changes)
- Witness receipts (proofs of publication)
- Delegations (if applicable)

This file provides the cryptographic proof that the DID document is authentic.

### How do I verify a did:webs DID?

1. Fetch the `did.json` and `keri.cesr` files
2. Verify the KERI event stream according to KERI rules
3. Ensure the DID document matches the current key state
4. Check witness receipts (if witnesses are used)
5. Verify any delegations (if the identifier is delegated)

The reference implementation handles this automatically.

### Can I use did:webs with existing web infrastructure?

Yes! `did:webs` works with:
- Standard web servers (Apache, Nginx, etc.)
- Static site hosting (GitHub Pages, Netlify, etc.)
- CDNs
- Cloud storage (S3, etc.)

You just need to serve two files: `did.json` and `keri.cesr`.

### What happens if my web server is compromised?

If an attacker compromises your web server, they can:
- ❌ Serve an old version of your DID document
- ❌ Serve a modified DID document

But they **cannot**:
- ✅ Forge a valid KERI event stream
- ✅ Create events signed by your keys
- ✅ Fool verifiers who check the KERI event stream

This is why verification of the `keri.cesr` file is critical.

### What are witnesses?

Witnesses are KERI nodes that observe and receipt key events. They provide:
- Distributed consensus without blockchain
- Duplicity detection (detecting conflicting events)
- Availability (multiple copies of the event log)
- Accountability (witnesses sign receipts)

Witnesses are optional but recommended for production use.

### What is pre-rotation?

Pre-rotation is a KERI feature that protects against key compromise. When you create or rotate keys, you commit to the next keys without revealing them. If your current keys are compromised, the attacker cannot rotate to their own keys because they don't know the pre-committed next keys.

### Can I move my did:webs to a different domain?

Yes! This is called DID portability. You can:
1. Move the `did.json` and `keri.cesr` files to a new location
2. Update the designated aliases in the DID document
3. Maintain the same AID (the cryptographic identifier)

The KERI event stream proves continuity across locations.

## Practical Questions

### How do I create a did:webs DID?

See the [Quick Start](quickstart.md) guide for step-by-step instructions. In summary:

1. Create a KERI AID
2. Generate `did.json` and `keri.cesr` files
3. Host the files on a web server
4. Your DID is ready to resolve!

### What software do I need?

To create and manage `did:webs` DIDs:
- **KERIpy** or **Signify** - KERI implementation
- **did-webs-resolver** - Reference implementation
- **Web server** - Any HTTPS server

To resolve `did:webs` DIDs:
- **did-webs-resolver** - Reference implementation
- **Universal Resolver** - Multi-method resolver

### How much does it cost?

`did:webs` has minimal costs:
- ✅ No blockchain transaction fees
- ✅ No special infrastructure required
- ✅ Just web hosting costs (often free)

### Is did:webs production-ready?

The `did:webs` method is:
- ✅ Fully specified
- ✅ Reference implementation available
- ✅ Deployed on GLEIF testnet
- ✅ Integrated with Universal Resolver
- 🚧 Still evolving (feedback welcome!)

Use it for development and testing. For production, evaluate based on your security requirements.

### Can I use did:webs for verifiable credentials?

Yes! `did:webs` DIDs can be used as:
- Credential issuers
- Credential subjects
- Verification method controllers

They work with standard W3C Verifiable Credentials.

### How do I host did:webs files on GitHub Pages?

1. Create a repository with your DID files
2. Enable GitHub Pages
3. Your DID would be: `did:webs:username.github.io:repo:AID`
4. Files at: `https://username.github.io/repo/AID/did.json`

Note: GitHub Pages uses HTTPS, which is required.

### What about privacy?

`did:webs` DIDs are public by design:
- DIDs are published on the web
- Anyone can resolve them
- The same AID across locations is correlatable

For privacy-sensitive use cases:
- Use different AIDs for different contexts
- Consider pairwise DIDs
- Evaluate if public DIDs are appropriate

### Can I use did:webs offline?

`did:webs` requires web access for:
- Publishing DID documents
- Resolving DIDs

However, KERI (the underlying protocol) supports offline scenarios. Future work may enable offline-first `did:webs` variants.

## Comparison Questions

### did:webs vs did:key?

- **did:key**: Stateless, no updates, no infrastructure
- **did:webs**: Stateful, supports updates, requires web hosting

Use `did:key` for ephemeral, non-updatable identifiers.  
Use `did:webs` for long-lived, updatable identifiers.

### did:webs vs did:peer?

- **did:peer**: Peer-to-peer, private, no publication
- **did:webs**: Public, web-based, discoverable

Use `did:peer` for private, peer-to-peer relationships.  
Use `did:webs` for public, discoverable identifiers.

### did:webs vs did:ion (or other blockchain DIDs)?

- **Blockchain DIDs**: Decentralized ledger, transaction costs, slower
- **did:webs**: Web-based, free, faster, no blockchain

Use blockchain DIDs if you need ledger-based consensus.  
Use `did:webs` for web-scale, cost-effective identifiers.

## Getting Help

### Where can I ask questions?

- **GitHub Issues**: [did-webs-resolver](https://github.com/GLEIF-IT/did-webs-resolver/issues)
- **Specification**: [tswg-did-method-webs-specification](https://github.com/trustoverip/tswg-did-method-webs-specification/issues)
- **KERI Community**: [WebOfTrust GitHub](https://github.com/WebOfTrust)

### How can I contribute?

See the [Contributing Guide](contributing.md) for ways to contribute to:
- Specification development
- Reference implementation
- Documentation
- Testing
- Community support

### Where can I learn more about KERI?

- **Website**: [keri.one](https://keri.one)
- **Specification**: [KERI Spec](https://trustoverip.github.io/kswg-keri-specification/)
- **GitHub**: [WebOfTrust](https://github.com/WebOfTrust)
- **Papers**: [KERI White Paper](https://github.com/SmithSamuelM/Papers)

## Still Have Questions?

If your question isn't answered here:

1. Check the [Specification](specification.md)
2. Review the [Implementation Guide](implementation/getting-started.md)
3. Try the [Quick Start](quickstart.md)
4. Ask on [GitHub](https://github.com/GLEIF-IT/did-webs-resolver/issues)
