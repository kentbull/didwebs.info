# Delegation in did:webs

Complete guide to delegated identifiers in `did:webs`.

## Overview

Delegation in `did:webs` enables hierarchical key management through KERI's delegated identifier mechanism. A delegated `did:webs` DID has its authority rooted in a delegator's identifier, creating a cryptographic chain of custody that enables:

- **Organizational hierarchies** - Parent organizations delegating to subsidiaries
- **Role-based identifiers** - Organizations delegating to departments or roles
- **Controlled authority** - Delegators can revoke delegation
- **Scalable trust** - Build trust hierarchies without central authorities

## What is Delegation?

In KERI and `did:webs`, delegation is the process where one identifier (the **delegator**) grants authority to create and manage another identifier (the **delegate**). The delegate's key events must be approved by the delegator, creating a verifiable chain of authority.

### Key Concepts

**Delegator**: The parent identifier that grants authority
- Controls whether delegation is approved
- Can revoke delegation by rotating to null keys
- Anchors delegation approval in their own KEL

**Delegate**: The child identifier that receives authority  
- Created with a `dip` (delegated inception) event instead of `icp`
- Must have delegator approval to complete inception
- Can be rotated by delegate controller (with delegator approval)

**Delegation Anchor**: The seal in the delegator's KEL approving the delegation
- Appears in an interaction (`ixn`) or rotation (`rot`) event
- References the delegate's inception event
- Provides cryptographic proof of authorization

## Delegation in the Specification

From the `did:webs` specification:

> The `di` field in the key state indicates the delegator AID (if any) for this identifier. If present, this creates a delegated identifier that requires approval from the delegator for all establishment events (inception and rotations).

### DID Document Representation

When a `did:webs` DID is delegated, the only indication in the DID document is a special service endpoint of type `DelegatorOOBI` that provides the delegator's OOBI. The verification methods remain the same as for non-delegated identifiers - they represent the delegate's keys, not the delegator's.

## Delegation Service Endpoint

### Purpose

The delegation service endpoint in a `did:webs` DID document serves two critical purposes:

1. **Discovery**: Allows verifiers to discover the delegator's identifier
2. **Verification**: Provides the OOBI needed to resolve and verify the delegator's KEL

### Structure

A delegation service endpoint has a specific structure:

```json
{
  "service": [{
    "id": "EDEvmKvGFjuip-J5dDw7sbVHxXA22s-pBO764CivsFt4",
    "type": "DelegatorOOBI",
    "serviceEndpoint": "http://witness.example.com:5642/oobi/EDelegatorAID.../witness/BWitnessAID..."
  }]
}
```

**Fields:**
- `id`: The SAID (digest) of the anchor block in the delegator's KEL that approves the delegation
- `type`: Always `"DelegatorOOBI"` for delegation service endpoints
- `serviceEndpoint`: The OOBI URL for resolving the delegator's identifier (KEL)

### How It's Generated

From PR #10, the delegation service endpoint generation algorithm:

```python
def gen_delegation_service(hby: habbing.Habery, pre: str, delpre: str):
    """Returns an array of delegation service endpoints for the delegator AID."""
    # Create seal referencing the delegate's inception event
    seal = dict(i=pre, s='0', d=pre)
    
    # Find the delegator's event that anchors this seal
    dserder = hby.db.fetchLastSealingEventByEventSeal(pre=delpre, seal=seal)
    
    # Extract the digest of the approval event
    approval_evt_digest = dserder.sad['a'][0]['d']
    
    # Get the resolved OOBI for the delegator
    del_oobi = oobiing.get_resolved_oobi(hby=hby, pre=delpre)
    
    if del_oobi is None:
        logger.error(f'No resolved OOBI found for delegate AID {delpre}')
        return []
    
    return [dict(
        id=approval_evt_digest, 
        type='DelegatorOOBI', 
        serviceEndpoint=del_oobi
    )]
```

**Step-by-step:**

1. **Create Seal**: Form a seal referencing the delegate's inception (sequence 0)
2. **Find Approval Event**: Query the database for the delegator's event containing this seal
3. **Extract Digest**: Get the SAID of the anchor block containing the approval
4. **Resolve OOBI**: Look up the delegator's OOBI from the resolver's database
5. **Return Service**: Create the service endpoint with the digest as `id` and OOBI as `serviceEndpoint`

## Complete Delegation Workflow

This section is a long guide showing how to set up your own delegated identifier with KERI.

### Phase 1: Delegator Inception

The delegator creates a normal (non-delegated) identifier:

```bash
kli init \
  --name delegator-keystore \
  --salt "0AAFmiyF5LgNB3AT6ZkdN25B" \
  --passcode "<your passcode>" \
  --config-dir "your/config/dir" \
  --config-file "your config file"

# Delegator creates their AID
kli incept \
  --name delegator-keystore \
  --passcode "<your passcode>" \
  --alias my-org \
  --file incept-config.json
```

**Output:**
```
Prefix  EDelegatorAID123456789012345678901234567890
```

### Phase 2: Delegate Inception Request

The delegate creates a delegated inception event:

```bash
kli init \
  --name delegate-keystore \
  --salt "0AAXlosF5LgNB3AT6Zkd99x2" \
  --passcode "<your passcode>" \
  --config-dir "your/config/dir" \
  --config-file "your config file"

# Delegate creates their AID with delegation request
kli incept \
  --name delegate-keystore \
  --alias my-dept \
  --delpre EDelegatorAID123456789012345678901234567890 \
  --file delegated-incept-config.json
```

Below in the sample events the AIDs and SAIDs are illustrative and are not valid. 

**Delegated Inception Event (`dip`):**

```json
{
  "v": "KERI10JSON000190_",
  "t": "dip",
  "d": "EDelegateAID123456789012345678901234567890",
  "i": "EDelegateAID123456789012345678901234567890",
  "s": "0",
  "kt": "1",
  "k": ["DPublicKey123456789012345678901234567890"],
  "nt": "1",
  "n": ["ENextKeyDigest123456789012345678901234567890"],
  "bt": "1",
  "b": ["BWitnessAID123456789012345678901234567890"],
  "c": [],
  "a": [],
  "di": "EDelegatorAID123456789012345678901234567890"
}
```

**Key field:**
- `di`: Delegator's identifier prefix

### Phase 3: Delegator Approval

The delegator approves the delegation by anchoring the delegate's inception in their KEL:

```bash
# Delegator approves delegation
kli delegate confirm \
  --name delegator-keystore \
  --alias my-org
```

**Delegator's Interaction Event with Anchor:**

```json
{
  "v": "KERI10JSON00013a_",
  "t": "ixn",
  "d": "EApprovalEvent123456789012345678901234567890",
  "i": "EDelegatorAID123456789012345678901234567890",
  "s": "1",
  "p": "EPreviousEvent123456789012345678901234567890",
  "a": [
    {
      "i": "EDelegateAID123456789012345678901234567890",
      "s": "0",
      "d": "EDelegateAID123456789012345678901234567890"
    }
  ]
}
```

**Anchor fields:**
- `a`: Array of anchors (seals)
- `i`: Delegate's identifier
- `s`: Delegate's sequence number (0 for inception)
- `d`: Delegate's inception event digest

### Phase 4: Completion

Once the delegator's approval event is published, receipted by witnesses, and the delegate discovers the approval:

1. The delegate's `dip` event comes out of escrow
2. The delegate's identifier is fully established
3. Witnesses receipt the delegate's inception
4. The delegation is complete

## DID Document with Delegation

A delegated `did:webs` DID document includes both witness services and a delegation service:

```json
{
  "id": "did:webs:example.com:dept:EDelegateAID123456789012345678901234567890",
  "verificationMethod": [
    {
      "id": "#DPublicKey123456789012345678901234567890",
      "type": "JsonWebKey",
      "controller": "did:webs:example.com:dept:EDelegateAID123456789012345678901234567890",
      "publicKeyJwk": {
        "kid": "DPublicKey123456789012345678901234567890",
        "kty": "OKP",
        "crv": "Ed25519",
        "x": "PublicKey123456789012345678901234567890"
      }
    }
  ],
  "service": [
    {
      "id": "#BWitnessAID123456789012345678901234567890/witness",
      "type": "witness",
      "serviceEndpoint": {
        "http": "http://witness.example.com:5642/",
        "tcp": "tcp://witness.example.com:5632/"
      }
    },
    {
      "id": "EApprovalEvent123456789012345678901234567890",
      "type": "DelegatorOOBI",
      "serviceEndpoint": "http://witness.example.com:5642/oobi/EDelegatorAID123456789012345678901234567890/witness/BWitnessAID..."
    }
  ],
  "alsoKnownAs": []
}
```

**Notice:**
- The `DelegatorOOBI` service endpoint
- The `id` is the digest of the delegator's approval event anchor block
- The `serviceEndpoint` is the OOBI for resolving the delegator

## Integration Test: test_resolver_with_witnesses

For a concrete example we review the integration test from the did:webs implementation repository, specifically the test at [`test_resolving.py:44`](https://github.com/GLEIF-IT/did-webs-resolver/blob/main/tests/dws/core/test_resolving.py#L44) which demonstrates the complete delegation flow.

The below is a guide through an abbreviated subset of that test to illustrate the general workflow necessary for verification of delegation.

### Test Setup

```python
def test_resolver_with_witnesses():
    """
    Integration test that spins up an actual witness and performs:
    1. Receipted inception for delegator
    2. Receipted inception for delegate with delegation
    3. Credential issuance for designated aliases
    4. Universal resolver endpoint testing
    
    Also includes the delegator for the AID controller to ensure the 
    service section of the DID document shows the delegator OOBI.
    """
```

### Step 1: Create Witness Network

```python
# Witness configuration
wit_salt = core.Salter(raw=b'abcdef0123456789').qb64
wit_cf = configing.Configer(name='wan', temp=False, reopen=True, clear=False)
wan_oobi = 'http://127.0.0.1:6642/oobi/BPwwr5VkI1b7ZA2mVbzhLL47UPjsGBX4WeO6WRv6c7H-/controller?name=Wan&tag=witness'

# Open witness habery
with HabbingHelpers.openHab(
    salt=bytes(wit_salt, 'utf-8'), 
    name='wan', 
    transferable=False, 
    temp=True, 
    cf=wit_cf
) as (wit_hby, wit_hab):
    # Witness is running...
```

### Step 2: Create Delegator

```python
# Delegator configuration
delegator_salt = b'0ABaQTNARS1U1u7VhP0mnEKz'
delegator_cf = configing.Configer(name='delegator', temp=False, reopen=True, clear=False)
delegator_cf.put(json.loads(aid_conf))

# Open delegator habery
with habbing.openHby(salt=delegator_salt, name='delegator', temp=True, cf=delegator_cf) as del_hby:
    # Incept delegator Hab
    del_hab = del_hby.makeHab(
        name='delegator', 
        isith='1', 
        icount=1, 
        toad=1, 
        wits=[wan_pre]
    )
    
    # Wait for witness receipts
    del_wit_rcptr_doer.msgs.append(dict(pre=del_hab.pre))
    while not del_wit_rcptr_doer.cues:
        doist.recur(deeds=wit_deeds + del_deeds)
```

### Step 3: Create Delegate with Delegation Request

```python
# Delegate configuration
delegate_salt = b'0AAB_Fidf5WeZf6VFc53IxVw'
delegate_cf = configing.Configer(name='delegate', temp=False, reopen=True, clear=False)

# Open delegate habery
with habbing.openHby(salt=delegate_salt, name='delegate', temp=True, cf=delegate_cf) as dgt_hby:
    # Create proxy hab first (required for delegation messaging)
    pxy_hab = dgt_hby.makeHab(
        name='proxy', 
        isith='1', 
        icount=1, 
        toad=1, 
        wits=[wan_pre]
    )
    
    # Create delegated hab (begins delegation workflow)
    dgt_hab = dgt_hby.makeHab(
        name='delegate', 
        delpre=del_hab.pre,  # Reference to delegator
        isith='1', 
        icount=1, 
        toad=1, 
        wits=[wan_pre]
    )
```

### Step 4: Exchange OOBIs

Both parties must resolve each other's witness OOBIs:

```python
# Get delegator OOBI and resolve with delegate
del_oobi = HabHelpers.generate_oobi(
    hby=del_hby, 
    alias='delegator', 
    role=kering.Roles.witness
)
HabHelpers.resolve_wit_oobi(doist, wit_deeds, dgt_hby, del_oobi, alias='delegator')

# Get proxy OOBI and resolve with delegator
proxy_oobi = HabHelpers.generate_oobi(
    hby=dgt_hby, 
    alias='proxy', 
    role=kering.Roles.witness
)
HabHelpers.resolve_wit_oobi(doist, wit_deeds, del_hby, proxy_oobi, alias='proxy')
```

### Step 5: Delegation Request and Approval

The delegate sends a delegation request, and the delegator approves. The Dipper and DipSealer are custom HIO processes (Doers) that support this integration test.

```python
# Dipper: Delegate-side doer that sends delegation request
dipper = keri_api.Dipper(
    hby=dgt_hby, 
    hab=dgt_hab, 
    proxy='proxy'
)

# DipSealer: Delegator-side doer that auto-approves delegation
dip_sealer = keri_api.DipSealer(
    hby=del_hby, 
    hab=del_hab, 
    witRcptrDoer=del_wit_rcptr_doer
)

# Run until delegation is complete
delegation_deeds = doist.enter(doers=[dipper, dip_sealer])
while not dipper.done:
    doist.recur(deeds=wit_deeds + del_deeds + dgt_deeds + delegation_deeds)
```

### Step 6: Wait for Escrow Processing

The delegate's `dip` event is held in escrow until the delegator's approval is processed:

```python
# Wait for witness receipts on delegate
dgt_wit_rcptr_doer.msgs.append(dict(pre=dgt_hab.pre))
while not dgt_wit_rcptr_doer.cues:
    doist.recur(deeds=wit_deeds + dgt_deeds)

# Wait for delegation request to show up for delegator
while not HabHelpers.has_delegables(del_hby.db):
    doist.recur(deeds=wit_deeds + del_deeds + dgt_deeds)
```

### Step 7: Generate did:webs DID Document and verify delegation

Once delegation is complete, generate the `did:webs` artifacts:

```python
# The delegate's HAB now has delpre attribute
assert hasattr(dgt_hab, 'delpre')
assert dgt_hab.delpre == del_hab.pre

# Generate DID document (automatically includes delegation service)
did_webs_diddoc = didding.generate_did_doc(
    dgt_hby, 
    rgy=regery, 
    did=did_webs_did, 
    aid=aid, 
    meta=meta
)

# Verify delegation service is present
services = did_webs_diddoc['didDocument']['service']
delegation_services = [s for s in services if s['type'] == 'DelegatorOOBI']
assert len(delegation_services) == 1
```

## Key Functions from PR #10

### gen_service_endpoints()

Modified to check for delegation and add delegation service:

```python
def gen_service_endpoints(hby: habbing.Habery, hab: habbing.Hab, kever: Kever, aid: str):
    """Generate service endpoints including both witness and delegation service endpoints."""
    serv_ends = []
    
    # Add witness and role endpoints
    if hab and hasattr(hab, 'fetchRoleUrls'):
        ends = hab.fetchRoleUrls(cid=aid)
        serv_ends.extend(add_ends(ends))
        ends = hab.fetchWitnessUrls(cid=aid)
        serv_ends.extend(add_ends(ends))
    else:
        ends = habs.get_role_urls(baser=hby.db, kever=kever)
        serv_ends.extend(add_ends(ends))
    
    # Add delegation service if this is a delegated identifier
    if hasattr(hab, 'delpre') and hab.delpre is not None:
        del_serv_end = gen_delegation_service(hby=hby, pre=hab.pre, delpre=hab.delpre)
        serv_ends.extend(del_serv_end)
    
    return serv_ends
```

### get_resolved_oobi()

New helper function to find the delegator's OOBI:

```python
def get_resolved_oobi(hby: habbing.Habery, pre: str) -> str | None:
    """Gets a resolved OOBI for a given identifier prefix or None if not found."""
    for (oobi,), obr in hby.db.roobi.getItemIter():
        if obr.cid == pre:
            return oobi
    return None
```

This searches the resolver's database for OOBIs that have been resolved, finding the one that corresponds to the delegator's identifier.

## Verification Process

When resolving a delegated `did:webs` DID:

### 1. Fetch DID Document and KERI Stream

```bash
curl https://example.com/dept/EDelegateAID.../did.json
curl https://example.com/dept/EDelegateAID.../keri.cesr
```

### 2. Parse Delegate's KEL

Verify the delegate's KEL contains a `dip` event with `di` field.

### 3. Extract Delegator Reference

From the `dip` event:
```json
{
  "di": "EDelegatorAID123456789012345678901234567890"
}
```

### 4. Resolve Delegator's OOBI

Use the `DelegatorOOBI` service endpoint to discover the delegator:

```json
{
  "serviceEndpoint": "http://witness:5642/oobi/EDelegatorAID.../witness/BWit..."
}
```

### 5. Fetch Delegator's KEL

Resolve the delegator's OOBI to get their KEL.

### 6. Find Approval Event

Search the delegator's KEL for an event containing a seal matching the delegate's inception:

```python
# Look for anchor seal in delegator's KEL
seal_to_find = {
    "i": "EDelegateAID123456789012345678901234567890",
    "s": "0",
    "d": "EDelegateAID123456789012345678901234567890"
}
```

### 7. Verify Approval

Confirm that:
- The delegator's event contains the anchor seal
- The event is properly signed by the delegator
- The event is receipted by witnesses
- The approval event digest matches the service endpoint `id`

### 8. Process Escrows

The resolver must process escrows in the correct order:

```python
# Process delegator KEL first
while aid not in hby.kevers:
    hby.kvy.processEscrows()  # Processes delegator's KEL
    # Now delegate's dip can come out of escrow
```

This is critical because the delegate's `dip` event waits in escrow until the delegator's approval is fully processed.

## did:keri Resolution with Delegation

PR #10 also added delegation support to `did:keri` resolution:

```python
# did:keri resolver checks for delegation
while aid not in hby.kevers:
    hby.kvy.processEscrows()
    # Process escrows to handle delegation approval
```

This ensures the delegate's KEL is fully processed including waiting for the delegator's approval anchor.

## Example Use Case

### Organizational Structure

```
GLEIF (Delegator)
  └─ QVI (Delegate)
      └─ Legal Entity (Delegate)
```

**GLEIF's DID:**
```
did:webs:gleif.org:EGLEIF_AID123456789012345678901234567890
```

**QVI's DID (delegated by GLEIF):**
```
did:webs:qvi.gleif.org:EQVI_AID123456789012345678901234567890
```

**QVI's DID Document includes:**
```json
{
  "service": [{
    "id": "EApprovalDigest...",
    "type": "DelegatorOOBI",
    "serviceEndpoint": "https://gleif.org/.../oobi/EGLEIF_AID.../witness/..."
  }]
}
```

Verifiers can:
1. Resolve the QVI's DID
2. See it's delegated (has `DelegatorOOBI` service)
3. Use the OOBI to resolve GLEIF's DID
4. Verify GLEIF approved the QVI's delegation
5. Trust the QVI based on GLEIF's authority


## Security Considerations

### Delegation Chain Verification

Verifiers MUST:
1. Verify the delegate's KEL including the `di` field
2. Resolve the delegator's identifier using the OOBI
3. Verify the delegator's KEL contains the approval anchor
4. Verify all signatures and receipts in both KELs
5. Check witness receipts for both delegator and delegate

### Revocation

A delegator can effectively revoke a delegation by:
1. Rotating their keys to new keys
2. Not approving future delegate rotations
3. Rotating to null keys (terminating the identifier)

### Key Compromise

If the delegate's keys are compromised:
- The delegate can rotate (with delegator approval)
- Pre-rotation protects against unauthorized rotation
- The delegator can refuse to approve malicious rotations

If the delegator's keys are compromised:
- All delegates under that delegator are at risk
- The delegator should rotate immediately

## Best Practices

### 1. Use Witnesses

Always use witnesses for both delegator and delegate:
```json
{
  "wits": ["Witness1", "Witness2", "Witness3"],
  "toad": 2
}
```

### 2. Document Delegation Relationships

Clearly document which identifiers are delegated:
- In organizational documentation
- In DID document metadata
- In designated aliases credentials

### 3. Monitor Delegations

Delegators should:
- Track all delegated identifiers
- Monitor delegation requests
- Review approvals regularly
- Maintain witness infrastructure

### 4. Plan for Revocation

Have a process for:
- Revoking compromised delegates
- Transitioning to new delegation structures
- Communicating revocations to verifiers

## References

- **PR #10**: [Delegation service support](https://github.com/GLEIF-IT/did-webs-resolver/pull/10)
- **Test Code**: [`test_resolving.py:44`](https://github.com/GLEIF-IT/did-webs-resolver/blob/main/tests/dws/core/test_resolving.py#L44)
- **Implementation**: `src/dws/core/didding.py`
- **Helper Functions**: `src/dws/core/oobiing.py`
- **KERI Delegation**: [KERI Specification](https://trustoverip.github.io/kswg-keri-specification/)

## Next Steps

- [Quick Start](quickstart.md) - Basic did:webs creation
- [Single-Sig Workflow](workflows/single-sig.md) - Non-delegated workflow
- [KERI Integration](keri.md) - Understanding KERI delegation
- [Examples](examples.md) - More delegation examples
