# KERI Integration

How `did:webs` integrates with KERI (Key Event Receipt Infrastructure).

## Overview

KERI provides the cryptographic foundation for `did:webs` security. This page explains:

- What KERI is and why it matters
- How KERI event logs work
- How `did:webs` uses KERI
- The `keri.cesr` file format

## What is KERI?

KERI (Key Event Receipt Infrastructure) is a protocol for managing cryptographic keys with a verifiable history. It provides:

- **Self-Certifying Identifiers**: Identifiers derived from cryptographic keys
- **Key Event Logs**: Immutable history of all key operations
- **Pre-Rotation**: Protection against key compromise
- **Witnesses**: Distributed consensus without blockchain
- **Delegated Identifiers**: Hierarchical key management

Learn more at [keri.one](https://keri.one) and the [KERI Specification](https://trustoverip.github.io/tswg-keri-specification/).

## Key Concepts

### Autonomic Identifier (AID)

An AID is a self-certifying identifier that:
- Is derived from the inception event
- Is globally unique
- Has a complete key event history
- Can be verified independently

**Example AID:**
```
EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
```

### Key Event Log (KEL)

A KEL is an ordered sequence of key events:
- **Inception** (`icp`): Birth of the identifier
- **Rotation** (`rot`): Key rotation
- **Interaction** (`ixn`): Non-key-state changes
- **Delegated Inception** (`dip`): Delegated identifier creation
- **Delegated Rotation** (`drt`): Delegated key rotation

### Key State

The current key state is calculated by walking the KEL:
- Current signing keys
- Next key commitments (pre-rotation)
- Current witnesses
- Delegation status

### Witnesses

Witnesses are KERI nodes that:
- Observe and receipt key events
- Provide distributed consensus
- Detect duplicity (conflicting events)
- Improve availability

## KERI Event Types

### Inception Event (icp)

The first event that creates an identifier:

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
- `t`: Event type (icp)
- `d`: Event digest (self-addressing)
- `i`: Identifier (AID)
- `s`: Sequence number (0 for inception)
- `kt`: Key threshold
- `k`: Current public keys
- `nt`: Next key threshold
- `n`: Next key digests (pre-rotation)
- `bt`: Witness threshold
- `b`: Witness identifiers
- `c`: Configuration traits
- `a`: Anchors

### Rotation Event (rot)

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
  "k": ["DNewKey123456789012345678901234567890123456"],
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
- `br`: Witness cuts (removed)
- `ba`: Witness adds (new)

### Interaction Event (ixn)

A non-establishment event:

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
- Maintain sequence continuity
- Update non-key-state information

## CESR Encoding

CESR (Composable Event Streaming Representation) is the encoding format for KERI events.

### Format

A CESR stream contains:
1. **Events**: JSON objects with KERI events
2. **Attachments**: CESR-encoded signatures and receipts

**Example:**

```
{"v":"KERI10JSON000159_","t":"icp",...}
-VA--AABAAAk_mN__NcXm2pynD2wxpPPUXVi8brekF_-F1XzTriX-PCMJNYUmzPeQ_2B24sUQjHuMB9oy_EuIrKDeCCucr0N
```

### Attachment Codes

- `-VA-`: Indexed signature attachment
- `-VAS`: Witness receipt attachment
- `-IAB`: Seal attachment

Learn more in the [CESR Specification](https://trustoverip.github.io/tswg-cesr-specification/).

## The keri.cesr File

The `keri.cesr` file contains the complete KERI event stream for an AID.

### Structure

```
[Inception Event][Attachments]
[Event 1][Attachments]
[Event 2][Attachments]
...
[Event N][Attachments]
```

### Example

```json
{"v":"KERI10JSON000159_","t":"icp","d":"EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",...}
-VA--AABAAAk_mN__NcXm2pynD2wxpPPUXVi8brekF_-F1XzTriX-PCMJNYUmzPeQ_2B24sUQjHuMB9oy_EuIrKDeCCucr0N
{"v":"KERI10JSON00013a_","t":"rot","d":"EPrcZNm-qeuxdjogRGLJJcGEBTUuy-jfJPTAzZhxdKHf",...}
-VA--AABAACbVNXfoXWo5u0AJWye5njlmQ1qiNYAJVDTMe1io6f8JoWTCaHwiCUDf76K4VdAOEMJ1cYpa1k1gqDMU3k3JaoO
```

### Verification

To verify a `keri.cesr` file:

1. Parse CESR stream into events
2. Verify inception event signature
3. Walk the KEL, verifying each event
4. Check witness receipts
5. Detect any duplicity
6. Calculate current key state

## Pre-Rotation

Pre-rotation protects against key compromise:

### How It Works

1. **Commit**: When creating/rotating keys, commit to next keys without revealing them
2. **Rotate**: When rotating, reveal the committed keys and commit to new next keys
3. **Verify**: Verifiers check that revealed keys match previous commitments

### Example

**Inception:**
```json
{
  "k": ["CurrentKey1"],
  "n": ["DigestOfNextKey1"]
}
```

**Rotation:**
```json
{
  "k": ["NextKey1"],  // Matches DigestOfNextKey1
  "n": ["DigestOfNextKey2"]
}
```

### Protection

If `CurrentKey1` is compromised, an attacker cannot rotate to their own keys because they don't know `NextKey1`.

## Witnesses

Witnesses provide distributed consensus:

### Witness Roles

- **Observe**: Watch for key events
- **Receipt**: Sign receipts for valid events
- **Detect**: Identify conflicting events (duplicity)
- **Publish**: Make receipts available

### Witness Threshold

The witness threshold (`bt`) specifies how many witness receipts are required:

```json
{
  "bt": "2",
  "b": ["Witness1", "Witness2", "Witness3"]
}
```

This requires 2 out of 3 witnesses to receipt events.

### Witness Receipts

Witnesses sign receipts that are included in the CESR stream:

```
-VAS-GAB0AAAAAAAAAAAAAAAAAAAAAABEPrcZNm-qeuxdjogRGLJJcGEBTUuy-jfJPTAzZhxdKHf
```

## Delegated Identifiers

KERI supports delegation:

### Delegator

The delegator approves delegation:

```json
{
  "t": "ixn",
  "a": [
    {
      "i": "DelegateeAID",
      "s": "0",
      "d": "DelegateeInceptionDigest"
    }
  ]
}
```

### Delegatee

The delegatee creates a delegated identifier:

```json
{
  "t": "dip",
  "di": "DelegatorAID",
  ...
}
```

### Verification

Verifiers must check both:
1. Delegatee's KEL
2. Delegator's approval in their KEL

## Integration with did:webs

### AID as DID Component

The KERI AID is the final component of the `did:webs` DID:

```
did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
                            └─────────────────┬────────────────────┘
                                              AID
```

### DID Document Generation

The DID document is generated from the current key state:

1. Walk the KEL
2. Calculate current key state
3. Map keys to verification methods
4. Map witnesses to services
5. Include designated aliases

### Verification

Resolvers MUST verify the `keri.cesr` file:

1. Fetch `keri.cesr`
2. Verify KERI event stream
3. Ensure DID document matches key state
4. Return verified DID document

## Security Properties

KERI provides `did:webs` with:

- ✅ **Verifiable History**: Complete audit trail of key operations
- ✅ **Key Compromise Protection**: Pre-rotation prevents unauthorized rotation
- ✅ **Duplicity Detection**: Witnesses detect conflicting events
- ✅ **Decentralized Trust**: No reliance on centralized authorities
- ✅ **Portability**: Same AID works across different web locations

## Next Steps

- [DID Documents](diddocuments.md) - Learn about DID document generation
- [Core Characteristics](core.md) - Understand core features
- [Specification](specification.md) - Read the full specification
- [KERI Specification](https://trustoverip.github.io/tswg-keri-specification/) - Deep dive into KERI
