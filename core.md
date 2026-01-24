# Core Characteristics

The core technical characteristics of the `did:webs` DID method.

## Method Name

1. The method name that identifies this DID method SHALL be: `webs`.
2. A DID that uses this method MUST begin with the following prefix: `did:webs:`.
3. Per the DID specification, this string MUST be lower case.
4. The remainder of the DID, after the prefix, MUST be the case-sensitive method-specific identifier (MSI).

> **Note**: When pronounced aloud, "webs" should become two syllables: the word "web" and the letter "s" (which stands for "secure"). Separating the final letter this way emphasizes that the method offers a security upgrade surpassing the one HTTPS gives to HTTP.

## Method-Specific Identifier

The `did:webs` method-specific identifier has two parts:

1. **Host with optional path** - Identical to `did:web`
2. **KERI AID** - Always the final component

### ABNF Grammar

```abnf
webs-did = "did:webs:" host [pct-encoded-colon port] *(":" path) ":" aid

; 'host' as defined in RFC 1035 and RFC 1123
host = *( ALPHA / DIGIT / "-" / "." )

; 'pct-encoded-colon' represents a percent-encoded colon
pct-encoded-colon = "%3A" / "%3a"

; 'port' number
port = 1*5(DIGIT)

; 'path' definition
path = 1*(ALPHA / DIGIT / "-" / "_" / "~" / "." / "/")

; 'aid' as base64 encoded value
aid = 1*(ALPHA / DIGIT / "+" / "/" / "=")
```

### Rules

1. The host MUST abide by RFC 1035, RFC 1123, and RFC 2181
2. A port MAY be included and the colon MUST be percent encoded (`%3a`)
3. Directories and subdirectories MAY be included, delimited by colons
4. The KERI AID MUST be derived from the inception event

> The AID is "just a path" - the final path element. This means a `did:webs` always has a path, so the "no path" version of `did:web` that uses `.well-known` is not supported.

## Target System

### Web Server Requirements

1. `did:webs` MUST read data from the web server referenced by the host
2. A `did:webs` DID MUST resolve using simple text transformation to HTTPS
3. A `did:web` and `did:webs` with the same MSI SHOULD return the same DID document (except for minor differences in `id`, `controller`, and `alsoKnownAs`)

### URL Transformation

Transform the DID to HTTPS URLs:

1. MUST replace `did:webs` with `https://`
2. MUST replace colons with slashes
3. MUST convert port encoding (`%3A` → `:`)
4. MUST append `/did.json` or `/keri.cesr`

### Examples

**Simple DID:**
```
did:webs:w3c-ccg.github.io:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP

→ https://w3c-ccg.github.io/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json
→ https://w3c-ccg.github.io/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/keri.cesr
```

**With Path:**
```
did:webs:w3c-ccg.github.io:user:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP

→ https://w3c-ccg.github.io/user/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json
→ https://w3c-ccg.github.io/user/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/keri.cesr
```

**With Port:**
```
did:webs:example.com%3A3000:user:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP

→ https://example.com:3000/user/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json
→ https://example.com:3000/user/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/keri.cesr
```

## AID Controlled Identifiers

### Replication

1. AID controlled identifiers MAY vary in how quickly they reflect current state
2. Different versions MAY reside in different locations
3. If KERI event streams differ, the smaller MUST be a prefix of the larger
4. If event streams diverge (fork), both MUST be considered invalid

### Duplicity Detection

The verification of the KERI event stream SHOULD provide mechanisms for detecting forking by using KERI witnesses and watchers.

> Since an AID is a unique cryptographic identifier inseparably bound to the KERI event stream, any DIDs with the same AID can be verifiably proven to have the same controller(s).

## Web Redirection

### DID Portability

1. A `did:webs` DID MAY be a stable identifier useful for generations
2. When a DID is moved to another location:
   - Its AID MUST not change
   - The same KERI event stream MUST be used
   - The designated aliases list MUST reflect the new location
3. If a resolver finds a newly named DID with the same AID, and the KERI event stream verifies, the resolver MAY consider resolution successful

### Stable Identifiers

The `id` property in the DID document will differ based on web location, but the AID remains constant, providing cryptographic continuity.

## CRUD Operations

### Create

Create a `did:webs` DID by:

1. Creating a KERI AID (inception event)
2. Generating `did.json` and `keri.cesr` files
3. Publishing files to a web server

### Read

Resolve a `did:webs` DID by:

1. Transforming DID to HTTPS URLs
2. Fetching `did.json` and `keri.cesr`
3. Verifying the KERI event stream
4. Returning the verified DID document

### Update

Update a `did:webs` DID by:

1. Performing KERI operations (rotation, interaction, etc.)
2. Regenerating `did.json` and `keri.cesr` files
3. Republishing files to the web server

### Delete (Deactivate)

Deactivate a `did:webs` DID by:

1. Creating a KERI rotation event to null keys
2. Regenerating files with deactivated status
3. Republishing files

Or simply remove the files from the web server (though this is less graceful).

## Security Model

### Trust Model

`did:webs` separates publication from trust:

- **Publication**: Uses web infrastructure (may be centralized)
- **Trust**: Derives from KERI cryptography (decentralized)

### Threat Protection

`did:webs` protects against:

- ✅ Key compromise (via pre-rotation)
- ✅ DNS hijacking (KERI verification detects tampering)
- ✅ Man-in-the-middle attacks (cryptographic signatures)
- ✅ Malicious webmasters (cannot forge KERI events)
- ✅ Replay attacks (sequence numbers)
- ✅ Fork attacks (witnesses detect duplicity)

### Trust Assumptions

`did:webs` assumes:

- Users can access the web
- KERI cryptography is sound
- Witnesses (if used) are not all compromised
- Users verify the KERI event stream

## Interoperability

### With did:web

A `did:webs` DID can be expressed as a `did:web` DID:

```
did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
→ did:web:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
```

Both resolve to the same `did.json` file, but only `did:webs` uses `keri.cesr`.

### With did:keri

The same AID can be used as a `did:keri` DID:

```
did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
→ did:keri:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
```

These can be listed in the `alsoKnownAs` field.

## Next Steps

- [DID Documents](diddocuments.md) - Learn about DID document generation
- [KERI Integration](keri.md) - Understand KERI integration
- [Specification](specification.md) - Read the full specification
