# Implementation Guide - Getting Started

A comprehensive guide for developers implementing `did:webs` support.

## Overview

This guide covers:
- Setting up a development environment
- Creating and managing KERI AIDs
- Generating `did:webs` artifacts
- Hosting DID documents and KERI event streams
- Resolving and verifying `did:webs` DIDs

## Prerequisites

### Knowledge Requirements

Familiarity with:
- **W3C DID Core**: Basic understanding of DIDs and DID documents
- **KERI**: Basic understanding of key event logs and AIDs
- **HTTP/HTTPS**: Web protocols and REST APIs
- **Cryptography**: Public key cryptography basics

### Software Requirements

- **Python 3.10+** (for reference implementation)
- **Docker & Docker Compose** (recommended for quick start)
- **Git** (for cloning repositories)
- **curl** or similar HTTP client (for testing)

## Installation

### Option 1: Docker (Recommended for Quick Start)

```bash
# Clone the repository
git clone https://github.com/GLEIF-IT/did-webs-resolver.git
cd did-webs-resolver

# Build images
docker compose build

# Start services
docker compose up -d

# Enter shell container
docker compose exec -it dws-shell /bin/bash
```

### Option 2: Local Python Environment

```bash
# Clone the repository
git clone https://github.com/GLEIF-IT/did-webs-resolver.git
cd did-webs-resolver

# Create virtual environment with uv
uv lock
uv sync

# Activate environment
source .venv/bin/activate

# Verify installation
dws --help
```

### Option 3: Install as Package

```bash
# Install from PyPI (when available)
pip install did-webs-resolver

# Or install from source
git clone https://github.com/GLEIF-IT/did-webs-resolver.git
cd did-webs-resolver
pip install -e .
```

## Core Concepts

### KERI AID (Autonomic Identifier)

The foundation of a `did:webs` DID is a KERI AID:

- **Self-certifying**: Derived from cryptographic keys
- **Portable**: Can be used across different systems
- **Verifiable**: Has a complete key event history

### DID Document (did.json)

The standard W3C DID document containing:
- Verification methods (public keys)
- Service endpoints
- Designated aliases (alsoKnownAs)

### KERI Event Stream (keri.cesr)

The cryptographic proof chain containing:
- Inception event (creation)
- Rotation events (key changes)
- Interaction events (anchors)
- Witness receipts (validation)

## Step-by-Step Implementation

You can refer to the workflow script in `did-webs-resolver/local/did_webs_workflow.sh` or roll your own by following along below.

### Step 1: Set Up KERI Infrastructure

**Start Witness Network (for development):**

```bash
# In a separate terminal (from keripy repository)
kli witness demo
```

This starts a local witness network with 6 witnesses.

**Or use Docker:**

```bash
docker compose up witnesses
```

### Step 2: Create a KERI AID

**Generate a cryptographic salt:**

```bash
kli salt
# Output: 0AAQmsjh-C7kAJZQEzdrzwB7
```

**Initialize KERI environment:**

```bash
kli init \
  --name my-keystore \
  --salt 0AAQmsjh-C7kAJZQEzdrzwB7 \
  --nopasscode \
  --config-dir ./config \
  --config-file my-config
```

**Create inception event:**

```bash
kli incept \
  --name my-keystore \
  --alias my-identifier \
  --file ./config/incept-config.json
```

**Output:**
```
Prefix  EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
	Public key 1:  DMJqIvb-YCWj7Ad2Hjq8wm0CgZcXTBcQ1Z-PaJtbv6ji
```

The `Prefix` is your AID!

### Step 3: Generate did:webs Artifacts

**Choose your web location:**

```
did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
```

**Generate files:**

```bash
dws did webs generate \
  --name my-keystore \
  --output-dir ./output \
  --did "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP" \
  --verbose
```

**Output files:**
- `./output/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json`
- `./output/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/keri.cesr`

### Step 4: Host the Files

**Option A: Static Web Server**

```bash
# Using Python's built-in server
cd ./output
python -m http.server 8000

# Files available at:
# http://localhost:8000/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json
# http://localhost:8000/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/keri.cesr
```

**Option B: did-webs-resolver Service**

```bash
dws did webs service \
  --name my-keystore \
  --static-files-dir ./output \
  --port 7677
```

**Option C: Production Web Server**

Upload files to your web server:

```bash
# Using SCP
scp -r ./output/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/ \
  user@example.com:/var/www/html/alice/

# Or using rsync
rsync -avz ./output/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/ \
  user@example.com:/var/www/html/alice/
```

### Step 5: Resolve the DID

**Using the CLI:**

```bash
dws did webs resolve \
  --name my-keystore \
  --did "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP" \
  --verbose
```

**Using HTTP API:**

```bash
curl -X GET "http://localhost:7703/1.0/identifiers/did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP"
```

**Using Universal Resolver:**

Visit [dev.uniresolver.io](https://dev.uniresolver.io/) and enter your DID.

### Step 6: Verify the Resolution

The resolver will:

1. ✅ Transform DID to HTTPS URLs
2. ✅ Fetch `did.json` and `keri.cesr`
3. ✅ Verify KERI event stream
4. ✅ Validate witness receipts
5. ✅ Check DID document matches key state
6. ✅ Return verified DID document

## Advanced Operations

### Key Rotation

Rotate your keys to new ones:

```bash
kli rotate \
  --name my-keystore \
  --alias my-identifier
```

**Regenerate artifacts:**

```bash
dws did webs generate \
  --name my-keystore \
  --output-dir ./output \
  --did "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP"
```

**Re-upload to web server.**

### Designated Aliases

Create an ACDC credential attesting to designated aliases:

**Create registry:**

```bash
kli vc registry incept \
  --name my-keystore \
  --alias my-identifier \
  --registry-name my-registry
```

**Issue designated aliases credential:**

```bash
kli vc create \
  --name my-keystore \
  --alias my-identifier \
  --registry-name my-registry \
  --schema EN6Oh5XSD5_q2Hgu-aqpdfbVepdpYpFlgz6zvJL5b_r5 \
  --data @./aliases-data.json \
  --rules @./aliases-rules.json
```

**Regenerate artifacts** to include the alsoKnownAs field.


### Delegated Identifiers

Create a delegated identifier:

```bash
# Delegator approves delegation
kli delegate \
  --name delegator-keystore \
  --alias delegator \
  --delegatee-prefix EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP

# Delegatee creates identifier
kli incept \
  --name delegatee-keystore \
  --alias delegatee \
  --file ./config/delegated-config.json
```

## Implementation Patterns

### Pattern 1: Static Generation

Generate artifacts once, host statically:

```python
from dws.core.generating import generate_did_webs_artifacts

# Generate
artifacts = generate_did_webs_artifacts(
    keystore_name="my-keystore",
    did="did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP"
)

# Save to files
with open("did.json", "w") as f:
    f.write(artifacts["did_document"])

with open("keri.cesr", "w") as f:
    f.write(artifacts["keri_stream"])
```

### Pattern 2: Dynamic Generation

Generate artifacts on-demand:

```python
from dws.core.resolving import resolve_did_webs

# Resolve dynamically
result = resolve_did_webs(
    did="did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
    verify=True
)

did_document = result["didDocument"]
```

### Pattern 3: Resolver Service

Run a resolver service:

```python
from dws.app.cli.commands.did.webs.resolver_service import start_resolver

# Start service
start_resolver(
    keystore_name="my-keystore",
    static_files_dir="./output",
    port=7703
)
```

## Testing

### Unit Tests

```bash
# Run all tests
pytest

# Run specific test file
pytest tests/dws/core/test_resolving.py

# Run with coverage
pytest --cov=src --cov-report=html
```


## Deployment

### Development

```bash
docker compose up
```

## Troubleshooting

See the [Commands Reference](commands.md) for detailed command documentation.

## Next Steps

- [Commands Reference](commands.md) - Detailed command documentation
- [Resolution Guide](resolution.md) - Deep dive into resolution
- [Examples](../examples.md) - More examples
- [FAQ](../faq.md) - Common questions
