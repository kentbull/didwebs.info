# Resolution Guide

Deep dive into `did:webs` DID resolution.

## Overview

DID resolution is the process of taking a DID string and returning a DID document. For `did:webs`, this involves:

1. **Transformation**: Convert the DID to HTTPS URLs
2. **Fetching**: Retrieve `did.json` and `keri.cesr` files
3. **Verification**: Validate the KERI event stream
4. **Validation**: Ensure the DID document matches the key state
5. **Response**: Return the verified DID document

## Resolution Algorithm

### Step 1: DID Parsing

Parse the `did:webs` DID into components:

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

**Validation:**
- Method MUST be `webs`
- Host MUST be valid domain name
- Port (if present) MUST be URL-encoded as `%3A` or `%3a`
- AID MUST be valid CESR-encoded identifier

### Step 2: DID-to-HTTPS Transformation

Transform the DID to HTTPS URLs:

**Algorithm:**

```python
def did_to_https(did: str) -> tuple[str, str]:
    """Transform did:webs DID to HTTPS URLs."""
    # Remove 'did:webs:' prefix
    path = did[9:]
    
    # Decode port separator
    path = path.replace('%3A', ':').replace('%3a', ':')
    
    # Split on colons
    parts = path.split(':')
    
    # Reconstruct as URL path
    url_path = '/'.join(parts)
    
    # Build URLs
    did_doc_url = f"https://{url_path}/did.json"
    keri_url = f"https://{url_path}/keri.cesr"
    
    return (did_doc_url, keri_url)
```

**Example:**

```
Input:  did:webs:example.com%3A3000:users:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP

Step 1: example.com%3A3000:users:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
Step 2: example.com:3000:users:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP
Step 3: example.com/3000/users/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP

Output: https://example.com:3000/users/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json
        https://example.com:3000/users/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/keri.cesr
```

### Step 3: Fetch Files

Fetch both files via HTTPS:

**Requirements:**
- MUST use HTTPS (not HTTP)
- MUST validate TLS certificates
- SHOULD follow redirects (up to a limit)
- SHOULD timeout after reasonable period (30s)

**Example:**

```python
import requests

def fetch_files(did_doc_url: str, keri_url: str) -> tuple[dict, str]:
    """Fetch DID document and KERI event stream."""
    # Fetch DID document
    did_response = requests.get(
        did_doc_url,
        timeout=30,
        verify=True,
        allow_redirects=True
    )
    did_response.raise_for_status()
    did_document = did_response.json()
    
    # Fetch KERI event stream
    keri_response = requests.get(
        keri_url,
        timeout=30,
        verify=True,
        allow_redirects=True
    )
    keri_response.raise_for_status()
    keri_stream = keri_response.text
    
    return (did_document, keri_stream)
```

### Step 4: Verify KERI Event Stream

Verify the KERI event stream according to KERI rules:

**Verification Steps:**

1. **Parse Events**: Parse CESR-encoded events
2. **Verify Signatures**: Check all event signatures
3. **Check Sequence**: Ensure sequence numbers are correct
4. **Validate Digests**: Verify event digests
5. **Check Witnesses**: Validate witness receipts
6. **Detect Duplicity**: Check for conflicting events
7. **Calculate Key State**: Walk the KEL to current state

**Example (conceptual):**

```python
def verify_keri_stream(keri_stream: str, aid: str) -> dict:
    """Verify KERI event stream and return key state."""
    # Parse events
    events = parse_cesr_stream(keri_stream)
    
    # Verify inception event
    inception = events[0]
    assert inception['t'] == 'icp'
    assert inception['i'] == aid
    verify_signature(inception)
    
    # Walk the KEL
    key_state = {'keys': inception['k'], 'next': inception['n']}
    
    for event in events[1:]:
        # Verify each event
        verify_signature(event, key_state['keys'])
        verify_digest(event)
        
        # Update key state if establishment event
        if event['t'] in ['rot', 'dip', 'drt']:
            key_state = update_key_state(key_state, event)
    
    # Verify witness receipts
    verify_witness_receipts(events)
    
    return key_state
```

### Step 5: Validate DID Document

Ensure the DID document matches the KERI key state:

**Validation Rules:**

1. **ID Match**: DID document `id` MUST match the requested DID
2. **Keys Match**: Verification methods MUST match current keys from KEL
3. **Witnesses Match**: Services MUST include current witnesses
4. **Consistency**: All fields MUST be consistent with key state

**Example:**

```python
def validate_did_document(did_document: dict, key_state: dict, did: str):
    """Validate DID document against key state."""
    # Check ID
    assert did_document['id'] == did
    
    # Check verification methods
    vm_keys = [vm['publicKeyJwk']['x'] for vm in did_document['verificationMethod']]
    kel_keys = [decode_key(k) for k in key_state['keys']]
    assert set(vm_keys) == set(kel_keys)
    
    # Check witnesses
    witness_services = [s for s in did_document.get('service', []) if s['type'] == 'witness']
    witness_aids = [extract_aid(s['id']) for s in witness_services]
    assert set(witness_aids) == set(key_state['witnesses'])
```

### Step 6: Return Result

Return the verified DID document in standard format:

```json
{
  "didDocument": {
    "id": "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP",
    "verificationMethod": [...],
    "service": [...],
    "alsoKnownAs": [...]
  },
  "didResolutionMetadata": {
    "contentType": "application/did+ld+json",
    "retrieved": "2024-01-01T00:00:00Z"
  },
  "didDocumentMetadata": {
    "created": "2024-01-01T00:00:00Z",
    "updated": "2024-01-01T00:00:00Z"
  }
}
```

## Error Handling

### Error Codes

| Code | Description | HTTP Status |
|------|-------------|-------------|
| `invalidDid` | DID format is invalid | 400 |
| `notFound` | DID document not found | 404 |
| `methodNotSupported` | DID method not supported | 501 |
| `representationNotSupported` | Representation not supported | 406 |
| `internalError` | Internal server error | 500 |
| `verificationError` | KERI verification failed | 400 |

### Error Response Format

```json
{
  "didDocument": null,
  "didResolutionMetadata": {
    "error": "notFound",
    "errorMessage": "DID document not found at https://example.com/alice/EKYGGh.../did.json"
  },
  "didDocumentMetadata": {}
}
```

### Common Errors

**Invalid DID Format:**

```json
{
  "error": "invalidDid",
  "errorMessage": "DID format is invalid: missing AID component"
}
```

**File Not Found:**

```json
{
  "error": "notFound",
  "errorMessage": "DID document not found at https://example.com/alice/EKYGGh.../did.json"
}
```

**Verification Failed:**

```json
{
  "error": "verificationError",
  "errorMessage": "KERI event stream verification failed: invalid signature on event 3"
}
```

**Network Error:**

```json
{
  "error": "internalError",
  "errorMessage": "Failed to fetch DID document: connection timeout"
}
```

## Caching

Resolvers MAY cache DID documents:

**Cache Considerations:**

- **TTL**: Use reasonable TTL (e.g., 5 minutes)
- **Invalidation**: Invalidate on key rotation
- **Freshness**: Check for updates periodically
- **Storage**: Store both `did.json` and `keri.cesr`

**Example:**

```python
from datetime import datetime, timedelta

cache = {}

def resolve_with_cache(did: str) -> dict:
    """Resolve DID with caching."""
    # Check cache
    if did in cache:
        entry = cache[did]
        if datetime.now() < entry['expires']:
            return entry['document']
    
    # Resolve fresh
    document = resolve_did(did)
    
    # Cache result
    cache[did] = {
        'document': document,
        'expires': datetime.now() + timedelta(minutes=5)
    }
    
    return document
```

## Performance Optimization

### Parallel Fetching

Fetch `did.json` and `keri.cesr` in parallel:

```python
import asyncio
import aiohttp

async def fetch_parallel(did_doc_url: str, keri_url: str):
    """Fetch files in parallel."""
    async with aiohttp.ClientSession() as session:
        did_task = session.get(did_doc_url)
        keri_task = session.get(keri_url)
        
        did_response, keri_response = await asyncio.gather(did_task, keri_task)
        
        did_document = await did_response.json()
        keri_stream = await keri_response.text()
        
        return (did_document, keri_stream)
```

### Connection Pooling

Reuse HTTP connections:

```python
import requests

session = requests.Session()
adapter = requests.adapters.HTTPAdapter(
    pool_connections=10,
    pool_maxsize=20
)
session.mount('https://', adapter)
```

### Witness Verification

Verify witness receipts in parallel:

```python
async def verify_witnesses_parallel(events, witnesses):
    """Verify witness receipts in parallel."""
    tasks = [verify_witness(event, witness) for witness in witnesses]
    results = await asyncio.gather(*tasks)
    return all(results)
```

## Security Considerations

### TLS Verification

Always verify TLS certificates:

```python
# Good
response = requests.get(url, verify=True)

# Bad
response = requests.get(url, verify=False)  # Don't do this!
```

### Timeout Protection

Set reasonable timeouts:

```python
response = requests.get(url, timeout=30)
```

### Redirect Limits

Limit redirect following:

```python
response = requests.get(url, allow_redirects=True, max_redirects=5)
```

### Size Limits

Limit response sizes:

```python
response = requests.get(url, stream=True)
if int(response.headers.get('content-length', 0)) > 10_000_000:
    raise ValueError("Response too large")
```

## Testing

### Unit Tests

```python
def test_did_to_https():
    """Test DID to HTTPS transformation."""
    did = "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP"
    did_doc_url, keri_url = did_to_https(did)
    
    assert did_doc_url == "https://example.com/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json"
    assert keri_url == "https://example.com/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/keri.cesr"
```

### Integration Tests

```python
def test_resolve_real_did():
    """Test resolution against real deployment."""
    did = "did:webs:hook.testnet.gleif.org%3A7702:dws:ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr"
    result = resolve_did(did)
    
    assert result['didDocument']['id'] == did
    assert len(result['didDocument']['verificationMethod']) > 0
```

## See Also

- [Getting Started Guide](getting-started.md)
- [Commands Reference](commands.md)
- [Specification](../specification.md)
- [Examples](../examples.md)
