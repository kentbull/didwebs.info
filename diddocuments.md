# DID Documents

How `did:webs` generates DID documents from KERI AIDs.

## Overview

A `did:webs` DID document is generated from the current key state of a KERI AID. The generation process involves:

1. Walking the KERI event log (KEL)
2. Calculating the current key state
3. Mapping KERI data to DID document properties
4. Including witness and service information

For the W3C ConditionalProof2022 context document see [this link](https://didwebs.info/context/ConditionalProof2022.jsonld.txt)

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
