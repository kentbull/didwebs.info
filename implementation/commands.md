# Commands Reference

Complete reference for `did-webs-resolver` commands.

## Overview

The `dws` command-line tool provides commands for:
- Generating `did:webs` artifacts
- Resolving `did:webs` and `did:keri` DIDs
- Running resolver services
- Managing KERI identifiers

## Installation

```bash
# Install from source
git clone https://github.com/GLEIF-IT/did-webs-resolver.git
cd did-webs-resolver
uv sync
source .venv/bin/activate

# Verify installation
dws --help
```

## Global Options

All commands support these global options:

```bash
--help, -h          Show help message
--version, -v       Show version information
```

## Commands

### `dws did webs generate`

Generate `did.json` and `keri.cesr` files for a `did:webs` DID.

**Usage:**

```bash
dws did webs generate \
  --name KEYSTORE_NAME \
  --did DID \
  --output-dir OUTPUT_DIR \
  [--verbose]
```

**Options:**

- `--name` (required): Name of the KERI keystore
- `--did` (required): The `did:webs` DID to generate artifacts for
- `--output-dir` (required): Directory to write output files
- `--verbose`: Show detailed output including generated files

**Example:**

```bash
dws did webs generate \
  --name my-keystore \
  --did "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP" \
  --output-dir ./output \
  --verbose
```

**Output:**

Creates two files:
- `{OUTPUT_DIR}/{AID}/did.json` - DID document
- `{OUTPUT_DIR}/{AID}/keri.cesr` - KERI event stream

---

### `dws did webs resolve`

Resolve a `did:webs` DID and verify its KERI event stream.

**Usage:**

```bash
dws did webs resolve \
  --name KEYSTORE_NAME \
  --did DID \
  [--verbose]
```

**Options:**

- `--name` (required): Name of the KERI keystore for verification
- `--did` (required): The `did:webs` DID to resolve
- `--verbose`: Show the resolved DID document

**Example:**

```bash
dws did webs resolve \
  --name my-keystore \
  --did "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP" \
  --verbose
```

**Output:**

```
Verification success for did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP

{
  "id": "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
  "verificationMethod": [...],
  ...
}
```

---

### `dws did webs service`

Run a `did:webs` service that serves static or dynamic artifacts.

**Usage:**

```bash
dws did webs service \
  --name KEYSTORE_NAME \
  [--static-files-dir DIR] \
  [--port PORT] \
  [--host HOST]
```

**Options:**

- `--name` (required): Name of the KERI keystore
- `--static-files-dir`: Directory containing static `did.json` and `keri.cesr` files
- `--port`: Port to listen on (default: 7677)
- `--host`: Host to bind to (default: 0.0.0.0)

**Example (Static Mode):**

```bash
dws did webs service \
  --name my-keystore \
  --static-files-dir ./output \
  --port 7677
```

**Example (Dynamic Mode):**

```bash
dws did webs service \
  --name my-keystore \
  --port 7677
```

**Endpoints:**

- `GET /{path}/{aid}/did.json` - Serve DID document
- `GET /{path}/{aid}/keri.cesr` - Serve KERI event stream

---

### `dws did webs resolver-service`

Run a Universal Resolver-compatible service.

**Usage:**

```bash
dws did webs resolver-service \
  --name KEYSTORE_NAME \
  --config-dir CONFIG_DIR \
  --config-file CONFIG_FILE \
  [--static-files-dir DIR] \
  [--port PORT] \
  [--host HOST]
```

**Options:**

- `--name` (required): Name of the KERI keystore
- `--config-dir` (required): Directory containing configuration files
- `--config-file` (required): Configuration file name (without extension)
- `--static-files-dir`: Directory for static files
- `--port`: Port to listen on (default: 7703)
- `--host`: Host to bind to (default: 0.0.0.0)

**Example:**

```bash
dws did webs resolver-service \
  --name my-keystore \
  --config-dir ./config \
  --config-file dws-resolver \
  --static-files-dir ./output \
  --port 7703
```

**Endpoints:**

- `GET /1.0/identifiers/{did}` - Universal Resolver API
- `GET /health` - Health check endpoint

**Response Format:**

```json
{
  "didDocument": {
    "id": "did:webs:...",
    "verificationMethod": [...],
    ...
  },
  "didResolutionMetadata": {
    "contentType": "application/did+ld+json"
  },
  "didDocumentMetadata": {}
}
```

---

### `dws did keri resolve`

Resolve a `did:keri` DID using an OOBI.

**Usage:**

```bash
dws did keri resolve \
  --name KEYSTORE_NAME \
  --did DID \
  --oobi OOBI_URL \
  [--verbose]
```

**Options:**

- `--name` (required): Name of the KERI keystore
- `--did` (required): The `did:keri` DID to resolve
- `--oobi` (required): OOBI URL for discovering the AID
- `--verbose`: Show the resolved DID document

**Example:**

```bash
dws did keri resolve \
  --name my-keystore \
  --did "did:keri:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP" \
  --oobi "http://witness:5642/oobi/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/witness/BBilc4-L3tFUnfM_wJr4S4OJanAv_VmF_dJNN6vkf2Ha" \
  --verbose
```

---

### `dws version`

Show version information.

**Usage:**

```bash
dws version
```

**Output:**

```
did-webs-resolver version 0.1.0
```

---

## KERI Commands (via `kli`)

The `did-webs-resolver` uses KERIpy's `kli` tool for KERI operations.

### `kli salt`

Generate a cryptographic salt.

```bash
kli salt
```

**Output:**
```
0AAQmsjh-C7kAJZQEzdrzwB7
```

---

### `kli init`

Initialize a KERI keystore.

```bash
kli init \
  --name KEYSTORE_NAME \
  --salt SALT \
  --nopasscode \
  --config-dir CONFIG_DIR \
  --config-file CONFIG_FILE
```

---

### `kli incept`

Create an inception event (create an AID).

```bash
kli incept \
  --name KEYSTORE_NAME \
  --alias ALIAS \
  --file CONFIG_FILE
```

**Config file example:**

```json
{
  "transferable": true,
  "wits": [
    "BBilc4-L3tFUnfM_wJr4S4OJanAv_VmF_dJNN6vkf2Ha"
  ],
  "toad": 1,
  "icount": 1,
  "ncount": 1,
  "isith": "1",
  "nsith": "1"
}
```

---

### `kli rotate`

Rotate keys for an AID.

```bash
kli rotate \
  --name KEYSTORE_NAME \
  --alias ALIAS
```

---

### `kli status`

Show the status of an AID.

```bash
kli status \
  --name KEYSTORE_NAME \
  --alias ALIAS
```

---

### `kli oobi resolve`

Resolve an OOBI to discover an AID.

```bash
kli oobi resolve \
  --name KEYSTORE_NAME \
  --oobi-alias ALIAS \
  --oobi OOBI_URL
```

---

### `kli vc registry incept`

Create a verifiable credential registry.

```bash
kli vc registry incept \
  --name KEYSTORE_NAME \
  --alias ALIAS \
  --registry-name REGISTRY_NAME
```

---

### `kli vc create`

Issue a verifiable credential.

```bash
kli vc create \
  --name KEYSTORE_NAME \
  --alias ALIAS \
  --registry-name REGISTRY_NAME \
  --schema SCHEMA_SAID \
  --data @data.json \
  --rules @rules.json
```

---

### `kli vc list`

List issued or received credentials.

```bash
kli vc list \
  --name KEYSTORE_NAME \
  --alias ALIAS \
  --issued
```

---

### `kli vc export`

Export a credential.

```bash
kli vc export \
  --name KEYSTORE_NAME \
  --alias ALIAS \
  --said CREDENTIAL_SAID \
  --chain
```

---

## Configuration Files

### Keystore Configuration

Location: `{CONFIG_DIR}/keri/cf/{KEYSTORE_NAME}.json`

```json
{
  "dt": "2024-01-01T00:00:00.000000+00:00",
  "iurls": [
    "http://witness1:5642/oobi/...",
    "http://witness2:5643/oobi/..."
  ],
  "keri.cesr.dir": "/path/to/cesr",
  "did.doc.dir": "/path/to/diddocs"
}
```

### Inception Configuration

```json
{
  "transferable": true,
  "wits": [
    "BBilc4-L3tFUnfM_wJr4S4OJanAv_VmF_dJNN6vkf2Ha",
    "BLskRTInXnMxWaGqcpSyMgo0nYbalW99cGZESrz3zapM"
  ],
  "toad": 1,
  "icount": 1,
  "ncount": 1,
  "isith": "1",
  "nsith": "1"
}
```

**Fields:**
- `transferable`: Whether keys can be rotated
- `wits`: List of witness AIDs
- `toad`: Witness threshold (number required)
- `icount`: Number of current keys
- `ncount`: Number of next keys (pre-rotation)
- `isith`: Current key threshold
- `nsith`: Next key threshold

---

## Environment Variables

```bash
# KERI keystore location
export KERI_KEYSTORE_DIR=/path/to/keystores

# did:webs output directory
export DWS_OUTPUT_DIR=/path/to/output

# Resolver service port
export DWS_PORT=7703

# Resolver service host
export DWS_HOST=0.0.0.0
```

---

## Exit Codes

- `0`: Success
- `1`: General error
- `2`: Invalid arguments
- `3`: File not found
- `4`: Network error
- `5`: Verification error

---

## Examples

### Complete Workflow

```bash
# 1. Generate salt
SALT=$(kli salt)

# 2. Initialize keystore
kli init --name my-keystore --salt $SALT --nopasscode

# 3. Create AID
kli incept --name my-keystore --alias my-id --file ./incept.json

# 4. Get AID
AID=$(kli status --name my-keystore --alias my-id | grep "Identifier:" | awk '{print $2}')

# 5. Generate did:webs artifacts
dws did webs generate \
  --name my-keystore \
  --did "did:webs:example.com:$AID" \
  --output-dir ./output

# 6. Start service
dws did webs service --name my-keystore --static-files-dir ./output

# 7. Resolve DID
dws did webs resolve --name my-keystore --did "did:webs:example.com:$AID"
```

---

## Troubleshooting

### Command Not Found

```bash
# Ensure virtual environment is activated
source .venv/bin/activate

# Or use full path
./venv/bin/dws --help
```

### Permission Denied

```bash
# Make scripts executable
chmod +x ./local/did_webs_workflow.sh

# Or run with bash
bash ./local/did_webs_workflow.sh
```

### Connection Refused

```bash
# Check if witnesses are running
docker compose ps witnesses

# Or start witnesses
kli witness demo
```

---

## See Also

- [Getting Started Guide](getting-started.md)
- [Resolution Guide](resolution.md)
- [Examples](../examples.md)
- [FAQ](../faq.md)
