# Quick Start

Get up and running with `did:webs` in minutes using the reference implementation.

## Prerequisites

You'll need:

- Docker and Docker Compose (recommended), OR
- Python 3.10+ with `uv` package manager
- Basic understanding of DIDs and KERI (helpful but not required)

## Try a Live Example

The easiest way to understand `did:webs` is to resolve a live DID:

### GLEIF Testnet Examples

Try these working `did:webs` DIDs on the GLEIF testnet:

**Example 1:**
```
did:webs:hook.testnet.gleif.org%3A7701:dws:EM27ujhiBJA24Ns-XeTRRfQwfe5V9m7xW1nAvkdJk7Ye
```

**Example 2:**
```
did:webs:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr
```

### Resolution Options

**Option 1: Universal Resolver**

Visit [dev.uniresolver.io](https://dev.uniresolver.io/) and paste a `did:webs` DID to see it resolve.

**Option 2: Direct HTTPS**

Resolve directly via the GLEIF testnet resolver:

```bash
curl https://hook.testnet.gleif.org:7703/1.0/identifiers/did:webs:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr
```

**Option 3: Fetch the Files Directly**

See the raw DID document and KERI event stream:

```bash
# DID Document
curl https://hook.testnet.gleif.org:7702/dws/ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr/did.json

# KERI Event Stream
curl https://hook.testnet.gleif.org:7702/dws/ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr/keri.cesr
```

## Create Your Own did:webs

### Using Docker (Recommended)

The reference implementation includes a complete Docker setup:

**Step 1: Clone the repository**

```bash
git clone https://github.com/GLEIF-IT/did-webs-resolver.git
cd did-webs-resolver
```

**Step 2: Start the services**

```bash
docker compose up -d
```

This starts:
- KERI witness network
- Static web server
- did:webs resolver service
- Shell container for commands

**Step 3: Enter the shell container**

```bash
docker compose exec -it dws-shell /bin/bash
cd /dws/scripts
```

**Step 4: Create a KERI identifier**

```bash
# Generate a cryptographic salt
kli salt
# Output: 0AAQmsjh-C7kAJZQEzdrzwB7

# Initialize KERI environment
kli init --name my-keystore \
  --salt 0AAQmsjh-C7kAJZQEzdrzwB7 \
  --nopasscode \
  --config-dir /dws/config/controller \
  --config-file get-started

# Create your AID (inception event)
kli incept \
  --name my-keystore \
  --alias my-controller \
  --file /dws/config/controller/incept-with-wan-wit.json
```

You'll see output like:
```
Prefix  EEMVke69ZjQAXoK3FTLtCwpyWOXx5qkhzIDqXAgYfPgh
	Public key 1:  DMJqIvb-YCWj7Ad2Hjq8wm0CgZcXTBcQ1Z-PaJtbv6ji
```

**Step 5: Generate did:webs artifacts**

```bash
dws did webs generate \
  --name my-keystore \
  --output-dir /dws/web/dws \
  --did "did:webs:dws-resolver%3a7677:dws:EEMVke69ZjQAXoK3FTLtCwpyWOXx5qkhzIDqXAgYfPgh"
```

This creates:
- `/dws/web/dws/EEMVke69ZjQAXoK3FTLtCwpyWOXx5qkhzIDqXAgYfPgh/did.json`
- `/dws/web/dws/EEMVke69ZjQAXoK3FTLtCwpyWOXx5qkhzIDqXAgYfPgh/keri.cesr`

**Step 6: Resolve your DID**

```bash
dws did webs resolve \
  --name my-keystore \
  --did "did:webs:dws-resolver%3a7677:dws:EEMVke69ZjQAXoK3FTLtCwpyWOXx5qkhzIDqXAgYfPgh"
```

Success output:
```
Verification success for did:webs:dws-resolver%3a7677:dws:EEMVke69ZjQAXoK3FTLtCwpyWOXx5qkhzIDqXAgYfPgh
```

**Step 7: View the DID document**

Add `--verbose` to see the full DID document:

```bash
dws did webs resolve \
  --name my-keystore \
  --did "did:webs:dws-resolver%3a7677:dws:EEMVke69ZjQAXoK3FTLtCwpyWOXx5qkhzIDqXAgYfPgh" \
  --verbose
```

### Using Local Python Environment

**Step 1: Install dependencies**

```bash
git clone https://github.com/GLEIF-IT/did-webs-resolver.git
cd did-webs-resolver

# Create virtual environment
uv lock
uv sync
source .venv/bin/activate
```

**Step 2: Start KERI witnesses**

In a separate terminal, from your `keripy` repository:

```bash
kli witness demo
```

**Step 3: Run the workflow**

```bash
./local/did_webs_workflow.sh
```

This script automates the creation, generation, and resolution process.

## Understanding the Output

### DID Document (did.json)

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
        "http": "http://witnesses:5642/",
        "tcp": "tcp://witnesses:5632/"
      }
    }
  ],
  "alsoKnownAs": []
}
```

### KERI Event Stream (keri.cesr)

The `keri.cesr` file contains CESR-encoded events:

```json
{"v":"KERI10JSON000159_","t":"icp","d":"EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",...}
-VA--AABAAAk_mN__NcXm2pynD2wxpPPUXVi8brekF_-F1XzTriX-PCMJNYUmzPeQ_2B24sUQjHuMB9oy_EuIrKDeCCucr0N
```

This includes:
- **Inception event** (`icp`) - Birth of the identifier
- **Receipts** - Witness signatures proving publication
- **Rotation events** (`rot`) - If keys have been rotated
- **Interaction events** (`ixn`) - Non-key-state changes

See the [keri.cesr file in the README](README.md#kericesr) for a more in depth example of what a valid keri.cesr stream looks like, with whitespace and annotations added for readability..

## Next Steps

Now that you have a working `did:webs` DID:

1. **Rotate keys**: Try `kli rotate --name my-keystore --alias my-controller`
2. **Add credentials**: Create designated aliases attestations
3. **Deploy to production**: Host on your own domain
4. **Integrate**: Use the resolver in your applications

### Learn More

- [Implementation Guide](implementation/getting-started.md) - Detailed developer documentation
- [Commands Reference](implementation/commands.md) - All available commands
- [Examples](examples.md) - More complex scenarios
- [Specification](specification.md) - Full technical specification

## Troubleshooting

### Common Issues

**Issue**: "Cannot connect to witnesses"
- **Solution**: Ensure `kli witness demo` is running (local) or witnesses are started (Docker)

**Issue**: "Verification failed"
- **Solution**: Check that the KERI event stream matches the DID document

**Issue**: "Port already in use"
- **Solution**: Stop conflicting services or change ports in `docker-compose.yml`

### Get Help

- **GitHub Issues**: [did-webs-resolver issues](https://github.com/GLEIF-IT/did-webs-resolver/issues)
- **Specification**: [tswg-did-method-webs-specification](https://github.com/trustoverip/tswg-did-method-webs-specification)
- **KERI Community**: [WebOfTrust GitHub](https://github.com/WebOfTrust)
