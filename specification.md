# Specification

The official `did:webs` DID Method Specification.

## Overview

This document specifies a [DID Method](https://www.w3.org/TR/did-core/#methods), `did:webs`, that is web-based but innovatively secure. Like its interoperable cousin, [`did:web`](https://w3c-ccg.github.io/did-method-web/), the `did:webs` method uses traditional web infrastructure to publish DIDs and make them discoverable. Unlike `did:web`, this method's trust is not rooted in DNS, webmasters, X.509, and certificate authorities. Instead, it uses KERI to provide a secure chain of cryptographic key events by those who control the identifier.

## Official Specification

The complete, normative specification is maintained by the Trust Over IP Foundation:

📄 **[View the Official Specification](https://trustoverip.github.io/tswg-did-method-webs-specification/)**

## Specification Repository

The specification source is available on GitHub:

🔗 **[tswg-did-method-webs-specification](https://github.com/trustoverip/tswg-did-method-webs-specification)**

## Key Sections

The specification covers:

### 1. Abstract
Overview of the `did:webs` method and its security model.

### 2. Core Characteristics
- Method name: `webs`
- Method-specific identifier format
- Target systems (web servers)
- ABNF grammar

### 3. DID Documents
- Generation from KERI AIDs
- Verification methods
- Service endpoints
- alsoKnownAs (designated aliases)

### 4. KERI Integration
- Key Event Logs (KELs)
- CESR encoding
- Witness networks
- Pre-rotation keys
- Delegated identifiers

### 5. Resolution
- DID-to-HTTPS transformation
- Fetching `did.json` and `keri.cesr`
- Verification process
- Error handling

### 6. DID Parameters
- Optional parameters for resolution
- Version-specific resolution
- Metadata

### 7. Security Considerations
- Threat model
- Trust assumptions
- Key compromise scenarios
- Duplicity detection

### 8. Privacy Considerations
- Correlation risks
- Metadata leakage
- Witness privacy

### 9. Implementation Guide
- Required KERI features
- Resolver implementation
- Service implementation
- Testing

## Quick Reference

### DID Format

```abnf
webs-did = "did:webs:" host [pct-encoded-colon port] *(":" path) ":" aid

host = *( ALPHA / DIGIT / "-" / "." )
pct-encoded-colon = "%3A" / "%3a"
port = 1*5(DIGIT)
path = 1*(ALPHA / DIGIT / "-" / "_" / "~" / "." / "/")
aid = 1*(ALPHA / DIGIT / "+" / "/" / "=")
```

### Examples

```
did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
did:webs:example.com%3A3000:users:bob:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr
did:webs:hook.testnet.gleif.org%3A7701:dws:EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye
```

### Resolution

**DID to HTTPS transformation:**

1. Replace `did:webs:` with `https://`
2. Replace colons with slashes
3. Decode port separator (`%3A` → `:`)
4. Append `/did.json` or `/keri.cesr`

**Example:**

```
did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP

→ https://example.com/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json
→ https://example.com/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/keri.cesr
```

## Normative References

The specification references:

- **W3C DID Core**: [https://www.w3.org/TR/did-core/](https://www.w3.org/TR/did-core/)
- **KERI Specification**: [https://trustoverip.github.io/kswg-keri-specification/](https://trustoverip.github.io/kswg-keri-specification/)
- **CESR Specification**: [https://trustoverip.github.io/kswg-cesr-specification/](https://trustoverip.github.io/kswg-cesr-specification/)
- **did:web Specification**: [https://w3c-ccg.github.io/did-method-web/](https://w3c-ccg.github.io/did-method-web/)
- **RFC 1035**: Domain Names - Implementation and Specification
- **RFC 1123**: Requirements for Internet Hosts
- **RFC 2181**: Clarifications to the DNS Specification

## Informative References

Additional resources:

- **ACDC Specification**: [https://trustoverip.github.io/kswg-acdc-specification/](https://trustoverip.github.io/kswg-acdc-specification/)
- **Universal Resolver**: [https://dev.uniresolver.io/](https://dev.uniresolver.io/)
- **GLEIF**: [https://www.gleif.org/](https://www.gleif.org/)

## Specification Status

- **Status**: Draft
- **Version**: Latest
- **Last Updated**: Check the [specification repository](https://github.com/trustoverip/tswg-did-method-webs-specification) for current version
- **Working Group**: Trust Over IP Foundation - Technology Stack Working Group

## Contributing to the Specification

The specification is developed openly by the Trust Over IP Foundation. To contribute:

1. Review the [Contributing Guide](https://github.com/trustoverip/tswg-did-method-webs-specification/blob/main/Contributing.md)
2. Join the [Trust Over IP Foundation](https://trustoverip.org/)
3. Participate in working group meetings
4. Submit issues or pull requests

## Related Specifications

### KERI Specification

The Key Event Receipt Infrastructure (KERI) specification defines the cryptographic foundation for `did:webs`.

📄 **[KERI Specification](https://trustoverip.github.io/kswg-keri-specification/)**

### CESR Specification

The Composable Event Streaming Representation (CESR) specification defines the encoding format for KERI events.

📄 **[CESR Specification](https://trustoverip.github.io/kswg-cesr-specification/)**

### ACDC Specification

The Authentic Chained Data Containers (ACDC) specification defines verifiable credentials that can be anchored to KERI identifiers.

📄 **[ACDC Specification](https://trustoverip.github.io/kswg-acdc-specification/)**

### did:web Specification

The `did:web` specification defines the simpler, less secure predecessor to `did:webs`.

📄 **[did:web Specification](https://w3c-ccg.github.io/did-method-web/)**

## Implementation Conformance

To claim conformance with the `did:webs` specification, an implementation MUST:

1. ✅ Support the DID format defined in the specification
2. ✅ Perform DID-to-HTTPS transformation correctly
3. ✅ Generate valid DID documents from KERI AIDs
4. ✅ Verify KERI event streams according to KERI rules
5. ✅ Support both `did.json` and `keri.cesr` files
6. ✅ Handle errors according to the specification
7. ✅ Implement required security considerations

Optional features:
- Pre-rotation keys
- Witnesses
- Delegated identifiers
- DID portability
- High assurance with DNS

## Testing

Test your implementation against:

- **GLEIF Testnet**: [Deployments](deployments.md)
- **Universal Resolver**: [dev.uniresolver.io](https://dev.uniresolver.io/)
- **Test Vectors**: Available in the [specification repository](https://github.com/trustoverip/tswg-did-method-webs-specification)

## Feedback

Submit feedback on the specification:

- **GitHub Issues**: [tswg-did-method-webs-specification/issues](https://github.com/trustoverip/tswg-did-method-webs-specification/issues)
- **Mailing List**: Trust Over IP Foundation working groups
- **Community**: [Trust Over IP](https://trustoverip.org/)

## License

The specification is developed under the Trust Over IP Foundation's [governance](https://trustoverip.org/our-work/governance-stack/) and licensing policies.

- **Copyright**: Trust Over IP Foundation
- **License**: See [COPYRIGHT_POLICY.md](https://github.com/trustoverip/tswg-did-method-webs-specification/blob/main/COPYRIGHT_POLICY.md)
