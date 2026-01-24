# DID Documents

How `did:webs` generates DID documents from KERI AIDs.

## Overview

A `did:webs` DID document is generated from the current key state of a KERI AID. The generation process involves:

1. Walking the KERI event log (KEL)
2. Calculating the current key state
3. Mapping KERI data to DID document properties
4. Including witness and service information

## DID Document Structure

A basic `did:webs` DID document:

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

## Key State to DID Document Mapping

### From KERI Key State Notice (KSN)

A KERI Key State Notice contains:

```json
{
  "v": "KERI10JSON000274_",
  "i": "EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
  "s": "1",
  "t": "ksn",
  "p": "ESORkffLV3qHZljOcnijzhCyRT0aXM2XHGVoyd5ST-Iw",
  "d": "EtgNGVxYd6W0LViISr7RSn6ul8Yn92uyj2kiWzt51mHc",
  "f": "1",
  "dt": "2021-11-04T12:55:14.480038+00:00",
  "et": "ixn",
  "kt": "1",
  "k": ["DTH0PwWwsrcO_4zGe7bUR-LJX_ZGBTRsmP-ZeJ7fVg_4"],
  "nt": "1",
  "n": ["E6qpfz7HeczuU3dAd1O9gPPS6-h_dCxZGYhU8UaDY2pc"],
  "bt": "3",
  "b": [
    "BGKVzj4ve0VSd8z_AmvhLg4lqcC_9WYX90k03q-R_Ydo",
    "BuyRFMideczFZoapylLIyCjSdhtqVb31wZkRKvPfNqkw",
    "Bgoq68HCmYNUDgOz4Skvlu306o_NY-NrYuKAVhk3Zh9c"
  ],
  "c": [],
  "ee": {
    "s": "0",
    "d": "ESORkffLV3qHZljOcnijzhCyRT0aXM2XHGVoyd5ST-Iw",
    "br": [],
    "ba": []
  },
  "di": ""
}
```

### Mapping Table

| Key State Field | Definition | DID Document Value |
|:---------------:|:-----------|:-------------------|
| `i` | AID value | Final component of DID `id` |
| `k` | Current public keys | `verificationMethod` with authentication/assertion |
| `n` | Next key digests | `verificationMethod` with capabilityInvocation |
| `b` | Witness AIDs | `service` entries with type "witness" |
| `di` | Delegator AID | `verificationMethod` with capabilityDelegation |

## Verification Methods

### Current Keys

Current signing keys from the `k` field become verification methods:

```json
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
```

**Properties:**
- `id`: Fragment identifier using the key
- `type`: "JsonWebKey" (W3C standard)
- `controller`: The DID itself
- `publicKeyJwk`: JWK representation of the key

### Key Types

KERI supports multiple key types:

| KERI Code | Algorithm | JWK crv | JWK kty |
|-----------|-----------|---------|---------|
| `D` | Ed25519 | Ed25519 | OKP |
| `E` | ECDSA secp256k1 | secp256k1 | EC |
| `1` | ECDSA secp256r1 | P-256 | EC |

### Pre-Rotation Keys

Next key digests from the `n` field MAY be included:

```json
{
  "id": "#EHUtdHSj8FhR9amkKwz1PQBzgdsQe52NKqynxdXVZuyQ",
  "type": "JsonWebKey",
  "controller": "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
  "publicKeyJwk": {
    "kid": "EHUtdHSj8FhR9amkKwz1PQBzgdsQe52NKqynxdXVZuyQ",
    "kty": "OKP",
    "crv": "Ed25519",
    "x": "HUtdHSj8FhR9amkKwz1PQBzgdsQe52NKqynxdXVZuyQ"
  }
}
```

These are digests, not actual keys, used for pre-rotation verification.

## Services

### Witness Services

Witnesses from the `b` field become service entries:

```json
{
  "id": "#BBilc4-L3tFUnfM_wJr4S4OJanAv_VmF_dJNN6vkf2Ha/witness",
  "type": "witness",
  "serviceEndpoint": {
    "http": "http://witness.example.com:5642/",
    "tcp": "tcp://witness.example.com:5632/"
  }
}
```

**Properties:**
- `id`: Fragment with witness AID
- `type`: "witness"
- `serviceEndpoint`: Witness URLs (from OOBI or configuration)

### Custom Services

Additional services MAY be included:

```json
{
  "id": "#messaging",
  "type": "DIDCommMessaging",
  "serviceEndpoint": "https://example.com/didcomm"
}
```

## alsoKnownAs (Designated Aliases)

The `alsoKnownAs` field lists other identifiers for the same AID:

```json
{
  "alsoKnownAs": [
    "did:web:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
    "did:keri:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
    "did:webs:backup.example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP"
  ]
}
```

These are populated from designated aliases ACDC credentials.

## Generation Algorithm

### Step 1: Walk the KEL

```python
def walk_kel(events):
    """Walk the KEL to calculate current key state."""
    state = None
    
    for event in events:
        if event['t'] == 'icp':  # Inception
            state = {
                'aid': event['i'],
                'sn': event['s'],
                'keys': event['k'],
                'next': event['n'],
                'witnesses': event['b'],
                'threshold': event['kt']
            }
        elif event['t'] == 'rot':  # Rotation
            state['sn'] = event['s']
            state['keys'] = event['k']
            state['next'] = event['n']
            # Update witnesses
            for cut in event.get('br', []):
                state['witnesses'].remove(cut)
            state['witnesses'].extend(event.get('ba', []))
        elif event['t'] == 'ixn':  # Interaction
            state['sn'] = event['s']
            # Process anchors
    
    return state
```

### Step 2: Generate Verification Methods

```python
def generate_verification_methods(keys, did):
    """Generate verification methods from keys."""
    methods = []
    
    for key in keys:
        method = {
            'id': f'#{key}',
            'type': 'JsonWebKey',
            'controller': did,
            'publicKeyJwk': key_to_jwk(key)
        }
        methods.append(method)
    
    return methods
```

### Step 3: Generate Services

```python
def generate_services(witnesses):
    """Generate service entries for witnesses."""
    services = []
    
    for witness in witnesses:
        service = {
            'id': f'#{witness}/witness',
            'type': 'witness',
            'serviceEndpoint': get_witness_endpoints(witness)
        }
        services.append(service)
    
    return services
```

### Step 4: Assemble DID Document

```python
def generate_did_document(did, state, aliases):
    """Generate complete DID document."""
    return {
        'id': did,
        'verificationMethod': generate_verification_methods(state['keys'], did),
        'service': generate_services(state['witnesses']),
        'alsoKnownAs': aliases
    }
```

## Validation

A valid `did:webs` DID document MUST:

1. ✅ Have `id` matching the requested DID
2. ✅ Have verification methods matching current keys
3. ✅ Have services matching current witnesses
4. ✅ Be consistent with the KERI event stream
5. ✅ Have valid JSON-LD structure

## Examples

See [Examples](examples.md) for complete DID document examples.

## Next Steps

- [KERI Integration](keri.md) - Understand KERI event streams
- [Resolution Guide](implementation/resolution.md) - Learn about resolution
- [Examples](examples.md) - See complete examples
