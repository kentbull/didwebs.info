# Introduction to did:webs

> **did:webs** - Web-based DIDs with KERI Security

The `did:webs` DID Method (`did:web` + Secure, like HTTPS) was developed to enable greater trust and security than `did:web` without compromising the simplicity and discoverability of web-based DIDs. 

## What is did:webs?

`did:webs` is a [DID Method](https://www.w3.org/TR/did-core/#methods) that combines the ease of use and discoverability of `did:web` with the cryptographic security of [KERI](https://keri.one) (Key Event Receipt Infrastructure).

Like `did:web`, the `did:webs` method uses traditional web infrastructure to publish DIDs and make them discoverable. Unlike `did:web`, this method's trust is **not** rooted in DNS, webmasters, X.509, and certificate authorities. Instead, it uses KERI to provide a secure chain of cryptographic key events by those who control the identifier.

```
did:webs:example.com%3A3000:users:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
│       │             │    │     │     │
│       │             │    │     │     └─ AID (KERI identifier)
│       │             │    │     └─────── Path component
│       │             │    └───────────── Path component
│       │             └────────────────── Port (URL-encoded)
│       └──────────────────────────────── Host
└──────────────────────────────────────── Method
```

## Core Features

The `did:webs` method provides several key features that complement `did:web`:

- **DID Portability** - Move DIDs between web locations while preserving history
- **DID-to-HTTPS transformation** - Uses the same simple transformation as `did:web`
- **Verifiable History** - Complete cryptographic chain of key events from inception to present
- **Self-Certifying Identifiers (SCIDs)** - Globally unique identifiers derived from inception events
- **Authorized Keys** - DID document derived from KERI and ACDC artifacts from authorized keys, literally from a CESR stream.
- **Pre-rotation Keys** - Prevents loss of control if active keys are compromised
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

See below for a sample did.json and keri.cesr stream to illustrate the nuts and bolts of how this works. 

## Why did:webs?

### The Problem with did:web

While `did:web` is wonderfully simple and familiar to developers, it has security limitations:

- Trust depends on DNS, TLS certificates, and certificate authorities
- Websites can be hacked or compromised
- DNS can be hijacked
- No cryptographic proof of key history
- Centralized trust in web infrastructure

### The did:webs Solution

`did:webs` separates **discovery** and **publication** from **trust**:

- **Discovery and Publication**: Still uses familiar web infrastructure (like `did:web`)
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

Or use `cURL` and resolve it from the GLIEF Testnet resolver instance:

```bash
curl https://hook.testnet.gleif.org:7703/1.0/identifiers/did:webs:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr
```

### did.json

The did.json is the DID Document generated from the keri.cesr stream or local KERI controller data store.

A sample DID document is:
```json
{
  "id": "did:web:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
  "verificationMethod": [
    {
      "id": "#DMxPdEQMvEE1y4SD2V9moEXpe6iCIpt_6yhbxxZ1VL81",
      "type": "JsonWebKey",
      "controller": "did:web:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
      "publicKeyJwk": {
        "kid": "DMxPdEQMvEE1y4SD2V9moEXpe6iCIpt_6yhbxxZ1VL81",
        "kty": "OKP",
        "crv": "Ed25519",
        "x": "zE90RAy8QTXLhIPZX2agRel7qIIim3_rKFvHFnVUvzU"
      }
    }
  ],
  "service": [
    {
      "id": "#BJqHtDoLT_K_XyOgr2ejBOqD9276TYMTg2EEqWKs-V0q/witness",
      "type": "witness",
      "serviceEndpoint": {
        "https": "https://wit1.testnet.gleif.org:5641/",
        "tcp": "tcp://wit1.testnet.gleif.org:5631/"
      }
    }
  ],
  "alsoKnownAs": [
    "did:web:hook.testnet.gleif.org%3a7702:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
    "did:webs:hook.testnet.gleif.org%3a7702:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
    "did:web:example.com:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
    "did:web:foo.com:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
    "did:webs:foo.com:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr"
  ]
}
```

### keri.cesr

The keri.cesr file contains cryptographic artifacts the diddoc is generated from

And CESR stream for the sample did:webs DID Doc above is shown below with whitespace added for readability. Actual CESR has no whitespace.

```jsonc
// Inception event
{
  "v": "KERI10JSON000159_",
  "t": "icp",
  "d": "ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
  "i": "ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
  "s": "0",
  "kt": "1",
  "k": ["DMxPdEQMvEE1y4SD2V9moEXpe6iCIpt_6yhbxxZ1VL81"],
  "nt": "1",
  "n": ["EDUYiOIC8ikCSXkN7UHBsYtvp2QjbcPOj7K13OU5IUdr"],
  "bt": "1",
  "b": ["BJqHtDoLT_K_XyOgr2ejBOqD9276TYMTg2EEqWKs-V0q"],
  "c": [],
  "a": []
}
// inception event attachments
-VA- // attached material quadlets (just a sequence of bytes) - group count code
  -AAB // controller indexed signatures - ControllerIdxSigs
    // controller signature
    AAC8q1O_p_lZx66ocraxSLo45xK7nmqMgATxr0HzzNXuMxepuBfcsGK05zqMBkpqzXL0SaBtQaEbRpzh0KQ2v98M
  -BAB // Witness indexed signatures - WitnessIdxSigs
    // witness signature
    AADxCMuT6xDiFwZhZE-fOJBPdWt7hx9T-QcemxkQoLaBjuPat2L3__igLUlzuXbTEx_LaNa965Q1gXZ3LzS7kSUP
  -EAB // first seen replay couples - FirstSeenReplayCouples
    // Sequence Number
    0AAAAAAAAAAAAAAAAAAAAAAA
    // Date time
    1AAG2025-08-06T06c23c11d584029p00c00

// interaction event for the registry TEL creation event - the vcp event
{
  "v": "KERI10JSON00013a_",
  "t": "ixn",
  "d": "EGlkjTlRSCGjC7pU7gsg7iOStaTYyfwWEVg-BubKAJ4Y",
  "i": "ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
  "s": "1",
  "p": "ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
  "a": [{
      "i": "EBjaRmzBalQ6CyKRBsJEbO_ERNIutpT4DwVfzX5BwIMH",
      "s": "0",
      "d": "EBjaRmzBalQ6CyKRBsJEbO_ERNIutpT4DwVfzX5BwIMH"
    }]
}
// interaction event attachments
-VA- // attached material quadlets (just a sequence of bytes) - group count code
  -AAB // controller indexed signatures - ControllerIdxSigs
    // controller signature
    AAD7Wd9jmcIlIzWwBk_D9A7x7_56OcxAZEJa4uMSx__k89YMqKZwjeDwOUMeDg7z1tfmsxQOXfkBeWi5Cpox8D4P
  -BAB // Witness indexed signatures - WitnessIdxSigs
    // witness signature
    AACyqJubkX3BMADWJBjBjoJ5dhZFKWTnCW__EKP2U5QQ0XnzfUtyQMxh8QV7oRlPXzdI4qHuczjrRAqgUSPIp7QA
  -EAB // first seen replay couples - FirstSeenReplayCouples
    // Sequence Number
    0AAAAAAAAAAAAAAAAAAAAAAB
    // Date time
    1AAG2025-08-06T06c23c14d079668p00c00

// interaction event anchoring the designated aliases ACDC issuance - iss event
{
  "v": "KERI10JSON00013a_",
  "t": "ixn",
  "d": "EBiySKwcFO0lHz8Mzei97LJiSySc_ctyEtNRiXbKZq-s",
  "i": "ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
  "s": "2",
  "p": "EGlkjTlRSCGjC7pU7gsg7iOStaTYyfwWEVg-BubKAJ4Y",
  "a": [{
      "i": "EByPClHOJwGJgk5G2idXi7J0M4qZU7d3_9N3AtbOL8j_",
      "s": "0",
      "d": "EGD1H4wQL2Tn9m8bp9bAIl5GUu6w-2DQGK1Kw0jNK_Eo"
    }]
}
// interaction event attachments for the iss event
-VA- // attached material quadlets (just a sequence of bytes) - group count code
  -AAB // controller indexed signatures - ControllerIdxSigs
    // controller signature
    AACkhKjXHDw6KTs0mDBgdKTvurLjA3jYoPT7bLPW0z-I8OEptLOTMytOt76vy8IsYRUtTW95nnKJnmt8vdhhAyIB
  -BAB // Witness indexed signatures - WitnessIdxSigs
    // witness signature
    AABr90OwKzM02ndOqSN5xmurKtyjp0ZPnBm6vmReRJTGaofTnMOMqrvm5VEclLC7qUfxlfGXpwuhOqgijadwI0gH
  -EAB // first seen replay couples - FirstSeenReplayCouples
    // Sequence Number
    0AAAAAAAAAAAAAAAAAAAAAAC
    // Date time
    1AAG2025-08-06T06c23c18d051612p00c00

// location scheme reply message - not part of the KEL, but part of the CESR stream that a diddoc is generated from.
{
  "v": "KERI10JSON000109_",
  "t": "rpy",
  "d": "EAVexvYonCqxXNNQ8208SLo3Afcg9W7d7eiNJ2FC8tMe",
  "dt": "2025-04-16T16:50:26.283032-07:00",
  "r": "/loc/scheme",
  "a": {
    "eid": "BJqHtDoLT_K_XyOgr2ejBOqD9276TYMTg2EEqWKs-V0q",
    "scheme": "https",
    "url": "https://wit1.testnet.gleif.org:5641/"
  }
}
// attachments for the reply (rpy) message
-VAi // attached material quadlets (just a sequence of bytes) - group count code
  -CAB // non-transferable receipt couples - NonTransReceiptCouples
    // witness AID
    BJqHtDoLT_K_XyOgr2ejBOqD9276TYMTg2EEqWKs-V0q
    // witness signature
    0BAg8reb-ciDO-qERm3Sw0v--6nTH5jVAAxAxMlz89Sk6jUwaJMLsTSzN0aIXXuZwCSS2WMfLCHdvTMr5zHhhjYA

// location scheme reply message - not part of the KEL, but part of the CESR stream that a diddoc is generated from.
{
  "v": "KERI10JSON000105_",
  "t": "rpy",
  "d": "ENAFmV935lXzYQfDKwgjU08o-AC5ZfqhGR2dtgka1kvq",
  "dt": "2025-04-16T16:50:26.283032-07:00",
  "r": "/loc/scheme",
  "a": {
    "eid": "BJqHtDoLT_K_XyOgr2ejBOqD9276TYMTg2EEqWKs-V0q",
    "scheme": "tcp",
    "url": "tcp://wit1.testnet.gleif.org:5631/"
  }
}
// attachments for the reply (rpy) message
-VAi // attached material quadlets (just a sequence of bytes) - group count code
  -CAB // non-transferable receipt couples - NonTransReceiptCouples
    // witness AID
    BJqHtDoLT_K_XyOgr2ejBOqD9276TYMTg2EEqWKs-V0q
    // witness signature
    0BAkXrIwv1_AhUBkG597Us8YcdlxfDRu7rJ0QUiTL7UmAsPnIaZt_hov4rrw4astrD1LKIKUkpv2KRu31e8RJ30I

// endpoint role authorization reply message - not part of the KEL, but part of the CESR stream that a diddoc is generated from.
{
  "v": "KERI10JSON000116_",
  "t": "rpy",
  "d": "EIUHDBQmdOf7B0TwHqREnB-_gGYa2b9exOcLJMylrp6P",
  "dt": "2025-04-16T16:50:26.283032-07:00",
  "r": "/end/role/add",
  "a": {
    "cid": "BJqHtDoLT_K_XyOgr2ejBOqD9276TYMTg2EEqWKs-V0q",
    "role": "controller",
    "eid": "BJqHtDoLT_K_XyOgr2ejBOqD9276TYMTg2EEqWKs-V0q"
  }
}
// attachments for the reply (rpy) message
-VAi // attached material quadlets (just a sequence of bytes) - group count code
  -CAB // non-transferable receipt couples - NonTransReceiptCouples
    // witness AID
    BJqHtDoLT_K_XyOgr2ejBOqD9276TYMTg2EEqWKs-V0q
    // witness signature
    0BBrZ8OdE5mQ59dYmPD6uqR-eV-v-6Noiw4XaHifrzXJFnMhZwF1IxEcVSfLoD3yVnQE1VhEh5aSjDv_NvDf0ckC

// registry inception vcp message from the transaction event log (TEL)
// not in KEL, though used to derive or verify the DID doc
{
  "v": "KERI10JSON0000ff_",
  "t": "vcp",
  "d": "EBjaRmzBalQ6CyKRBsJEbO_ERNIutpT4DwVfzX5BwIMH",
  "i": "EBjaRmzBalQ6CyKRBsJEbO_ERNIutpT4DwVfzX5BwIMH",
  "ii": "ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
  "s": "0",
  "c": ["NB"],
  "bt": "0",
  "b": [],
  "n": "0AANdQj5oAOSrjA0qN-mHDf4"
}
// attachments for the vcp TEL message
-VAS // attached material quadlets (just a sequence of bytes) - group count code
  -GAB // seal source couple - SealSourceCouples
    // sequence number
    0AAAAAAAAAAAAAAAAAAAAAAB
    // SAID of interaction event referencing this VCP message.
    EGlkjTlRSCGjC7pU7gsg7iOStaTYyfwWEVg-BubKAJ4Y

// designated aliases ACDC issuance event (iss) in the TEL
// not in KEL, though used to derive or verify the DID doc
{
  "v": "KERI10JSON0000ed_",
  "t": "iss",
  "d": "EGD1H4wQL2Tn9m8bp9bAIl5GUu6w-2DQGK1Kw0jNK_Eo",
  "i": "EByPClHOJwGJgk5G2idXi7J0M4qZU7d3_9N3AtbOL8j_",
  "s": "0",
  "ri": "EBjaRmzBalQ6CyKRBsJEbO_ERNIutpT4DwVfzX5BwIMH",
  "dt": "2025-08-06T06:23:16.671347+00:00"
}
// attachments for the vcp TEL message
-VAS // attached material quadlets (just a sequence of bytes) - group count code
  -GAB // seal source couple - SealSourceCouples
    // sequence number
    0AAAAAAAAAAAAAAAAAAAAAAC
    // SAID of interaction event referencing this ISS message.
    EBiySKwcFO0lHz8Mzei97LJiSySc_ctyEtNRiXbKZq-s

// Designated Aliases ACDC
{
  "v": "ACDC10JSON0005fe_",
  "d": "EByPClHOJwGJgk5G2idXi7J0M4qZU7d3_9N3AtbOL8j_",
  "i": "ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
  "ri": "EBjaRmzBalQ6CyKRBsJEbO_ERNIutpT4DwVfzX5BwIMH",
  "s": "EN6Oh5XSD5_q2Hgu-aqpdfbVepdpYpFlgz6zvJL5b_r5",
  "a": {
    "d": "EDfPxWujNCO8QDC2_X9dI-ph608MCLfCEbblUgQDzO4R",
    "dt": "2025-08-06T06:23:16.671347+00:00",
    "ids": [
      "did:web:hook.testnet.gleif.org%3a7702:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
      "did:webs:hook.testnet.gleif.org%3a7702:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
      "did:web:example.com:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
      "did:web:foo.com:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr",
      "did:webs:foo.com:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr"
    ]
  },
  "r": {
    "d": "EEVTx0jLLZDQq8a5bXrXgVP0JDP7j8iDym9Avfo8luLw",
    "aliasDesignation": {
      "l": "The issuer of this ACDC designates the identifiers in the ids field as the only allowed namespaced aliases of the issuer's AID."
    },
    "usageDisclaimer": {
      "l": "This attestation only asserts designated aliases of the controller of the AID, that the AID controlled namespaced alias has been designated by the controller. It does not assert that the controller of this AID has control over the infrastructure or anything else related to the namespace other than the included AID."
    },
    "issuanceDisclaimer": {
      "l": "All information in a valid and non-revoked alias designation assertion is accurate as of the date specified."
    },
    "termsOfUse": {
      "l": "Designated aliases of the AID must only be used in a manner consistent with the expressed intent of the AID controller."
    }
  }
}
// seal source triple
-IAB
  // SAID of the ACDC - in the interaction event seal anchoring this ACDC issuance
  EByPClHOJwGJgk5G2idXi7J0M4qZU7d3_9N3AtbOL8j_
  // sequence number of the iss event in its own sub-TEL - zero here, or AAAAA...
  0AAAAAAAAAAAAAAAAAAAAAAA
  // SAID of the iss event issuing this ACDC - also in the ixn evt seal
  EGD1H4wQL2Tn9m8bp9bAIl5GUu6w-2DQGK1Kw0jNK_Eo
```


## Learn More

- **Specification Repository**: [tswg-did-method-webs-specification](https://github.com/trustoverip/tswg-did-method-webs-specification)
- **Reference Implementation**: [did-webs-resolver](https://github.com/GLEIF-IT/did-webs-resolver)
- **KERI**: [keri.one](https://keri.one)
- **Trust Over IP**: [trustoverip.org](https://trustoverip.org)
