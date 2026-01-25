# Single-Sig Workflow - Local Deployment

Complete walkthrough of the single-signature `did:webs` workflow using the local deployment from the did-webs-resolver repository.

## Overview

This guide walks through the [`did_webs_workflow.sh`](https://github.com/GLEIF-IT/did-webs-resolver/blob/main/local/did_webs_workflow.sh) script, which demonstrates a complete end-to-end single-signature `did:webs` workflow including:

1. Creating a KERI AID with witnesses
2. Issuing designated aliases credentials
3. Generating `did:webs` artifacts
4. Hosting artifacts with a static server
5. Resolving via CLI and Universal Resolver API
6. Resolving as both `did:webs` and `did:keri`

## Prerequisites

### Software Requirements

- **Python 3.10+** with `uv` package manager
- **KERIpy** installed with `kli` command available
- **did-webs-resolver** installed with `dws` command available
- **Running witness network** (`kli witness demo`)

### Repository Setup

```bash
# Clone and setup did-webs-resolver
git clone https://github.com/GLEIF-IT/did-webs-resolver.git
cd did-webs-resolver

# Install dependencies
uv lock
uv sync
source .venv/bin/activate
```

### Start Witness Network

In a separate terminal:

```bash
# From keripy repository
kli witness demo
```

This starts a local witness network with 6 witnesses on ports 5642-5647.

## Workflow Script Overview

The script is located at `./local/did_webs_workflow.sh` and can be run with:

```bash
./local/did_webs_workflow.sh
```

Optional metadata mode:
```bash
./local/did_webs_workflow.sh true  # Includes DID resolution metadata
```

### Configuration

```bash
CONFIG_DIR="./local/config"
SCRIPTS_DIR="./local"
WEB_DIR="./local/web"
ARTIFACT_PATH="dws"
```

Key variables:
- `DOMAIN="127.0.0.1"` - Local domain
- `DID_PORT=7678` - Port for static file server
- `WAN_PRE="BBilc4-L3tFUnfM_wJr4S4OJanAv_VmF_dJNN6vkf2Ha"` - Witness prefix

## Step-by-Step Walkthrough

### Step 1: Verify Dependencies

The script checks for required commands:

```bash
# Check kli is available
command -v kli >/dev/null 2>&1 || { 
    echo "kli is not installed or not available on the PATH. Aborting."; 
    exit 1; 
}

# Check dws is available
command -v dws >/dev/null 2>&1 || { 
    echo "dws is not installed or not available on the PATH. Aborting."; 
    exit 1; 
}
```

### Step 2: Check Witness Availability

```bash
function check_witnesses() {
  WIT_HOST=http://"${DOMAIN}":5642
  WIT_OOBI="${WIT_HOST}/oobi/${WAN_PRE}"
  curl $WIT_OOBI >/dev/null 2>&1
  status=$?
  if [ $status -ne 0 ]; then
      echo "Witness server not running at ${WIT_HOST}"
      exit 1
  else
      echo "Witness server is running at ${WIT_OOBI}"
  fi
}
check_witnesses
```

**Example Output:**
```
Witness server is running at http://127.0.0.1:5642/oobi/BBilc4-L3tFUnfM_wJr4S4OJanAv_VmF_dJNN6vkf2Ha
```

This verifies the witness network is accessible before proceeding. The witness responds with its inception event in CESR format.

### Step 3: Initialize KERI Environment

```bash
CTLR_KEYSTORE="dws-controller"
CTLR_ALIAS="labs-id"

# Initialize keystore with salt and config
kli init \
  --name "${CTLR_KEYSTORE}" \
  --salt 0AAFmiyF5LgNB3AT6ZkdN25B \
  --nopasscode \
  --config-dir "${CONFIG_DIR}/controller" \
  --config-file "${CTLR_KEYSTORE}"
```

**Example Output:**
```
KERI Keystore created at: /Users/$USER/.keri/ks/dws-controller
KERI Database created at: /Users/$USER/.keri/db/dws-controller
KERI Credential Store created at: /Users/$USER/.keri/reg/dws-controller
```

**What happens:**
- Creates keystore at `/usr/local/var/keri/ks/dws-controller` on Unix/Linux or at `/Users/$USER/.keri/ks/dws-controller` on Mac OS
- Loads configuration from `./local/config/controller/keri/cf/dws-controller.json`
- Resolves witness OOBIs from configuration
- No passcode for easy automation

### Step 4: Create AID (Inception Event)

```bash
# Create inception event for controller AID
kli incept \
  --name "${CTLR_KEYSTORE}" \
  --alias "${CTLR_ALIAS}" \
  --file "${CONFIG_DIR}/controller/incept-with-wan-wit.json"
```

**Inception config** (`incept-with-wan-wit.json`):
```json
{
  "transferable": true,
  "wits": ["BBilc4-L3tFUnfM_wJr4S4OJanAv_VmF_dJNN6vkf2Ha"],
  "toad": 1,
  "icount": 1,
  "ncount": 1,
  "isith": "1",
  "nsith": "1"
}
```

**Example Output:**
```
Waiting for witness receipts...
Prefix  EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft
	Public key 1:  DMJqIvb-YCWj7Ad2Hjq8wm0CgZcXTBcQ1Z-PaJtbv6ji
```

**What happened:**
- Witness receipts confirmed (witnesses signed your inception event)
- Your new AID (identifier prefix) was created: `EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft`
- Your public key is displayed for reference

The `Prefix` is your AID!

### Step 5: Verify AID Created

```bash
function get_aid() {
  MY_AID=$(kli aid --name "${CTLR_KEYSTORE}" --alias "${CTLR_ALIAS}")
  MY_OOBI="http://${DOMAIN}:5642/oobi/${MY_AID}/witness/${WAN_PRE}"
  
  # Verify OOBI is accessible
  curl "${MY_OOBI}" >/dev/null 2>&1
  status=$?
  if [ $status -ne 0 ]; then
      echo "Controller AID ${MY_AID} not found at ${MY_OOBI}"
      exit 1
  else
      echo "Controller ${CTLR_ALIAS} with AID ${MY_AID} setup complete."
  fi
}
get_aid
```

### Step 6: Create Designated Aliases Registry

Designated aliases allow you to attest to alternative identifiers:

```bash
DESG_ALIASES_REG="did:webs_designated_aliases"

kli vc registry incept \
  --name "${CTLR_KEYSTORE}" \
  --alias "${CTLR_ALIAS}" \
  --registry-name "${DESG_ALIASES_REG}"
```

**Output:**
```
Registry: did:webs_designated_aliases(ERegistry123...)
	created for Identifier Prefix: EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft
```

### Step 7: Resolve Designated Aliases Schema

```bash
DESG_ALIASES_SCHEMA="EN6Oh5XSD5_q2Hgu-aqpdfbVepdpYpFlgz6zvJL5b_r5"

kli oobi resolve \
  --name "${CTLR_KEYSTORE}" \
  --oobi-alias "designated-alias-public" \
  --oobi "https://weboftrust.github.io/oobi/${DESG_ALIASES_SCHEMA}"
```

**Example Output:**
```
Resolved OOBI EN6Oh5XSD5_q2Hgu-aqpdfbVepdpYpFlgz6zvJL5b_r5
Added schema EN6Oh5XSD5_q2Hgu-aqpdfbVepdpYpFlgz6zvJL5b_r5
```

This resolves the schema from the public WebOfTrust registry so your keystore knows the structure of designated aliases credentials.

### Step 8: Create Designated Aliases JSON

Generate the aliases data:

```bash
timestamp=$(kli time | tr -d '[:space:]')

cat > designated_aliases.json << EOF
{
  "d": "",
  "dt": "${timestamp}",
  "ids": [
    "did:web:${DOMAIN}%3a${DID_PORT}:${MY_AID}",
    "did:webs:${DOMAIN}%3a${DID_PORT}:${MY_AID}",
    "did:web:example.com:${MY_AID}",
    "did:web:foo.com:${MY_AID}",
    "did:webs:foo.com:${MY_AID}"
  ]
}
EOF

# Add self-addressing identifier (SAID)
kli saidify --file designated_aliases.json
```

### Step 9: Issue Designated Aliases Credential

```bash
kli vc create \
  --name "${CTLR_KEYSTORE}" \
  --alias "${CTLR_ALIAS}" \
  --registry-name "${DESG_ALIASES_REG}" \
  --schema "${DESG_ALIASES_SCHEMA}" \
  --data @designated_aliases.json \
  --rules @"${SCRIPTS_DIR}/schema/rules/desig-aliases-public-schema-rules.json"
```

**Output:**
```
Creating designated aliases credential...
Waiting for TEL event witness receipts
Sending TEL events to witnesses
EPxvM9FEbFq-wyKtWzNZfUig7v6lH4M6n3ebKRoyldlt has been created.
```

### Step 10: Generate did:webs Artifacts

```bash
DID_WEBS_DID="did:webs:${DOMAIN}%3A${DID_PORT}:${ARTIFACT_PATH}:${MY_AID}"

dws did webs generate \
  --name "${CTLR_KEYSTORE}" \
  --config-dir ./local/config/controller \
  --config-file "${CTLR_KEYSTORE}" \
  --output-dir "${WEB_DIR}/${ARTIFACT_PATH}" \
  --did "${DID_WEBS_DID}"
```

**Example DID:**
```
did:webs:127.0.0.1%3A7678:dws:EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft
```

**Generated files:**
- `./local/web/dws/EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft/did.json`
- `./local/web/dws/EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft/keri.cesr`

### Step 11: Start Static File Server

```bash
dws did webs resolver-service \
  --http 7678 \
  --name "static-service" \
  --config-dir="${CONFIG_DIR}/controller" \
  --config-file "static-service" \
  --static-files-dir "${WEB_DIR}" \
  --did-path "${ARTIFACT_PATH}" &

static_service_pid=$!
```

This starts a server at `http://127.0.0.1:7678` serving files from `./local/web`.

### Step 12: Initialize Resolver Keystore

The resolver needs to know about the designated aliases schema:

```bash
kli init \
  --name "dws-other" \
  --nopasscode \
  --config-dir "${CONFIG_DIR}/controller" \
  --config-file "dws-other"

kli oobi resolve \
  --name "dws-other" \
  --oobi-alias "designated-alias-public" \
  --oobi "https://weboftrust.github.io/oobi/${DESG_ALIASES_SCHEMA}"
```

This prevents designated aliases ACDCs from ending up in the missing signature escrow.

### Step 13: Resolve did:webs via CLI

```bash
dws did webs resolve \
  --name "dws-other" \
  --did "${DID_WEBS_DID}"
```

**Success output:**
```
Verification success for did:webs:127.0.0.1%3A7678:dws:EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft
```

With `--verbose` flag:
```bash
dws did webs resolve \
  --name "dws-other" \
  --did "${DID_WEBS_DID}" \
  --verbose
```

Shows the complete DID document with verification methods, services, and designated aliases.

### Step 14: Resolve did:keri with OOBI

```bash
DID_KERI_DID="did:keri:${MY_AID}"
MY_OOBI="http://${DOMAIN}:5642/oobi/${MY_AID}/witness/${WAN_PRE}"

dws did keri resolve \
  --name "dws-resolver" \
  --did "${DID_KERI_DID}" \
  --oobi "${MY_OOBI}"
```

**Success output:**
```
DID resolution succeeded for did:keri:EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft
```

### Step 15: Start Universal Resolver Service

```bash
# Initialize resolver keystore
kli init \
  --name "dws-resolver" \
  --nopasscode \
  --config-dir "${CONFIG_DIR}/controller" \
  --config-file "dws-resolver"

kli oobi resolve \
  --name "dws-resolver" \
  --oobi-alias "designated-alias-public" \
  --oobi "https://weboftrust.github.io/oobi/${DESG_ALIASES_SCHEMA}"

# Start universal resolver service
dws did webs resolver-service \
  --http 7676 \
  --name "dws-resolver" \
  --config-dir="${CONFIG_DIR}/controller" \
  --config-file "dws-resolver" &

resolver_service_pid=$!
```

This starts a Universal Resolver-compatible service at `http://127.0.0.1:7676`.

### Step 16: Resolve via Universal Resolver API

**Resolve did:webs:**

```bash
curl "http://127.0.0.1:7676/1.0/identifiers/${DID_WEBS_DID}"
```

**Resolve did:keri:**

```bash
curl "http://127.0.0.1:7676/1.0/identifiers/${DID_KERI_DID}?oobi=${MY_OOBI}"
```

**Response format:**

```json
{
  "didDocument": {
    "id": "did:webs:127.0.0.1%3A7678:dws:EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft",
    "verificationMethod": [...],
    "service": [...],
    "alsoKnownAs": [...]
  },
  "didResolutionMetadata": {
    "contentType": "application/did+ld+json"
  },
  "didDocumentMetadata": {}
}
```

## Running the Script

### Basic Usage

```bash
cd did-webs-resolver
./local/did_webs_workflow.sh
```

The script will:
1. Check for running witnesses
2. Create or reuse existing AID
3. Generate designated aliases
4. Issue credentials
5. Generate did:webs artifacts
6. Start static file server
7. Resolve via CLI
8. Start universal resolver
9. Resolve via HTTP API
10. Display success messages

### With Metadata

```bash
./local/did_webs_workflow.sh true
```

This includes DID resolution metadata in responses.

### Interactive Mode

The script includes pause points:

```bash
pause "Press Enter to generate the did:webs DID document and KERI CESR stream..."
pause "Press Enter to resolve the did:webs DID using CLI resolution..."
```

Press Enter at each pause to proceed through the workflow step-by-step.

## Key Components Explained

### AID Creation

**Configuration variables:**

```bash
CTLR_KEYSTORE="dws-controller"  # Keystore name
CTLR_ALIAS="labs-id"            # Human-readable alias
```

**Inception with witness:**

The `incept-with-wan-wit.json` config specifies:
- `transferable: true` - Supports key rotation
- `wits`: List of witness AIDs
- `toad: 1` - Witness threshold (1 receipt required)
- `isith: "1"` - Current key threshold (single-sig)
- `nsith: "1"` - Next key threshold

### Designated Aliases

**Why designated aliases?**

They allow you to attest that multiple DID representations point to the same AID:

```json
{
  "ids": [
    "did:web:127.0.0.1%3a7678:EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft",
    "did:webs:127.0.0.1%3a7678:EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft",
    "did:web:example.com:EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft",
    "did:webs:foo.com:EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft"
  ]
}
```

These appear in the DID document's `alsoKnownAs` field.

### DID Generation

**DID format:**

```bash
did:webs:{domain}%3A{port}:{path}:{AID}
```

**Example:**
```
did:webs:127.0.0.1%3A7678:dws:EBFn5ge82EQwxp9eeje-UMEXF-v-3dlfbdVMX_PNjSft
```

**Generated files:**
- `did.json` - W3C DID document
- `keri.cesr` - KERI event stream

### Static vs Dynamic Serving

**Static mode** (used in script):
```bash
--static-files-dir "${WEB_DIR}"
```
Serves pre-generated files from directory.

**Dynamic mode** (alternative):
```bash
# No --static-files-dir flag
```
Generates artifacts on-demand when requested.

### Resolution Methods

The workflow demonstrates three resolution methods:

**1. CLI Resolution:**
```bash
dws did webs resolve --name "keystore" --did "did:webs:..."
```

**2. Universal Resolver API:**
```bash
curl "http://127.0.0.1:7676/1.0/identifiers/did:webs:..."
```

**3. Direct File Access:**
```bash
curl "http://127.0.0.1:7678/dws/EBFn5ge82.../did.json"
curl "http://127.0.0.1:7678/dws/EBFn5ge82.../keri.cesr"
```

## Directory Structure

```
did-webs-resolver/
└── local/
    ├── config/
    │   └── controller/
    │       ├── incept-with-wan-wit.json
    │       └── keri/cf/
    │           ├── dws-controller.json
    │           ├── dws-other.json
    │           ├── dws-resolver.json
    │           └── static-service.json
    ├── schema/
    │   └── rules/
    │       └── desig-aliases-public-schema-rules.json
    ├── web/
    │   └── dws/
    │       └── {AID}/
    │           ├── did.json
    │           └── keri.cesr
    ├── color-printing.sh
    ├── designated_aliases.json
    └── did_webs_workflow.sh
```

## Verification

### Check Generated Files

```bash
# List generated artifacts
ls -l ./local/web/dws/*/

# View DID document
cat ./local/web/dws/EBFn5ge82.../did.json | jq

# View KERI stream (first few lines)
head -c 500 ./local/web/dws/EBFn5ge82.../keri.cesr
```

### Test HTTP Endpoints

```bash
# Static file server
curl http://127.0.0.1:7678/dws/EBFn5ge82.../did.json | jq

# Universal resolver
curl http://127.0.0.1:7676/1.0/identifiers/did:webs:127.0.0.1%3A7678:dws:EBFn5ge82... | jq
```

### Check Witness Receipts

```bash
# View issued credentials
kli vc list \
  --name "dws-controller" \
  --alias "labs-id" \
  --issued

# Check AID status
kli status \
  --name "dws-controller" \
  --alias "labs-id"
```

## Cleanup

The script includes automatic cleanup on exit:

```bash
trap cleanup INT
trap cleanup ERR
trap cleanup EXIT

function cleanup() {
  if [[ -n "${static_service_pid}" ]]; then
    kill "${static_service_pid}"
  fi
  if [[ -n "${resolver_service_pid}" ]]; then
    kill "${resolver_service_pid}"
  fi
}
```

This ensures services are stopped when the script exits.

### Manual Cleanup

```bash
# Kill any running services
pkill -f "dws did webs"

# Remove generated files
rm -rf ./local/web/dws/*/

# Remove keystores (optional)
rm -rf ~/.keri/ks/dws-*
rm -rf ~/.keri/db/dws-*
```

## Advanced Operations

### Key Rotation

After initial setup, rotate keys:

```bash
# Rotate keys
kli rotate \
  --name "dws-controller" \
  --alias "labs-id"

# Regenerate artifacts
dws did webs generate \
  --name "dws-controller" \
  --output-dir "./local/web/dws" \
  --did "${DID_WEBS_DID}"
```

### Add Service Endpoints

Create custom service endpoints:

```bash
# Add a service endpoint to your AID's configuration
kli ends add \
  --name "dws-controller" \
  --alias "labs-id" \
  --eid "EServiceAID..." \
  --role "service" \
  --http "https://service.example.com"
```

### Multi-Witness Setup

Modify `incept-with-wan-wit.json` to use multiple witnesses:

```json
{
  "transferable": true,
  "wits": [
    "BBilc4-L3tFUnfM_wJr4S4OJanAv_VmF_dJNN6vkf2Ha",
    "BLskRTInXnMxWaGqcpSyMgo0nYbalW99cGZESrz3zapM",
    "BIKKuvBwpmDVA4Ds-EpL5bt9OqPzWPja2LigFYZN2YfX"
  ],
  "toad": 2,
  "icount": 1,
  "ncount": 1,
  "isith": "1",
  "nsith": "1"
}
```

This requires 2 out of 3 witnesses to receipt events.

## Troubleshooting

### Witnesses Not Running

**Error:**
```
Witness server not running at http://127.0.0.1:5642
```

**Solution:**
```bash
# In separate terminal, start witnesses
kli witness demo
```

### Command Not Found

**Error:**
```
kli is not installed or not available on the PATH
```

**Solution:**
```bash
# Activate virtual environment
source .venv/bin/activate

# Or install KERIpy
pip install keripy
```

### Files Not Generated

**Error:**
```
No such file or directory: ./local/web/dws/...
```

**Solution:**
```bash
# Create web directory
mkdir -p ./local/web/dws

# Verify output-dir is correct
dws did webs generate --output-dir "./local/web/dws" ...
```

### Resolution Fails

**Error:**
```
DID resolution failed for did:webs:...
```

**Solutions:**
1. Verify static server is running
2. Check files exist at the path
3. Verify KERI stream is valid
4. Check witness receipts are present
5. Process escrows if needed

## Production Considerations

### For Production Use

1. **Use Real Domain**: Replace `127.0.0.1` with your actual domain
2. **Use HTTPS**: Ensure TLS certificates are configured
3. **Use Multiple Witnesses**: At least 3 witnesses with threshold of 2
4. **Secure Keystores**: Use passphrases and secure storage
5. **Monitor Services**: Set up health checks and monitoring
6. **Backup Keys**: Securely backup keystore and salts
7. **Document OOBIs**: Keep records of witness and service OOBIs

### Security Checklist

- ✅ Use secure salts (not the example salt!)
- ✅ Enable passcodes for keystores
- ✅ Use multiple witnesses
- ✅ Set appropriate witness thresholds
- ✅ Use HTTPS for all endpoints
- ✅ Validate TLS certificates
- ✅ Monitor for duplicity
- ✅ Backup keystores securely
- ✅ Document recovery procedures

## Script Source

View the complete script:

**GitHub**: [did_webs_workflow.sh](https://github.com/GLEIF-IT/did-webs-resolver/blob/main/local/did_webs_workflow.sh)

**Local**: `./local/did_webs_workflow.sh` (in did-webs-resolver repository)

## Next Steps

- [Delegation](delegation.md) - Learn about delegated identifiers
- [Commands Reference](implementation/commands.md) - Detailed command documentation
- [Quick Start](quickstart.md) - Docker-based quick start
- [Examples](examples.md) - More workflow examples

## Summary

This single-signature workflow demonstrates:

✅ Complete KERI AID lifecycle  
✅ Witness network integration  
✅ Designated aliases attestation  
✅ Static artifact generation  
✅ Multiple resolution methods  
✅ Universal Resolver compatibility  

Perfect for learning `did:webs` fundamentals before moving to multi-sig or delegated scenarios!
