# Static Resources

This directory contains static JSON-LD context files and other resources that are served alongside the documentation.

## Available Resources

### JSON-LD Contexts

#### ConditionalProof2022.jsonld

A JSON-LD context for Conditional Proof 2022.

**Access URLs:**

- **Local**: http://localhost:3000/sample-context-docs/ConditionalProof2022.jsonld
- **GitHub Pages**: https://kentbull.github.io/didwebs.info/sample-context-docs/ConditionalProof2022.jsonld

**Usage in code:**

```json
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
    "https://kentbull.github.io/didwebs.info/sample-context-docs/ConditionalProof2022.jsonld"
  ],
  "type": ["VerifiableCredential"],
  ...
}
```

**Direct download:**

```bash
# Download the context file
curl -O https://kentbull.github.io/didwebs.info/sample-context-docs/ConditionalProof2022.jsonld

# Or with wget
wget https://kentbull.github.io/didwebs.info/sample-context-docs/ConditionalProof2022.jsonld
```

## Adding New Resources

To add new static resources:

1. **Place files in appropriate directory**:
   ```bash
   # For JSON-LD contexts
   cp my-context.jsonld sample-context-docs/
   
   # For schemas
   mkdir -p static/schemas
   cp my-schema.json static/schemas/
   ```

2. **Commit and push**:
   ```bash
   git add sample-context-docs/
   git commit -m "Add new context file"
   git push origin main
   ```

3. **Access via URL**:
   ```
   https://kentbull.github.io/didwebs.info/sample-context-docs/my-context.jsonld
   ```

## MIME Types

GitHub Pages automatically serves files with correct MIME types:

- `.jsonld` → `application/ld+json`
- `.json` → `application/json`
- `.txt` → `text/plain`
- `.md` → `text/markdown`

## CORS

GitHub Pages serves files with appropriate CORS headers, making them accessible from any origin for use in JSON-LD contexts and verifiable credentials.

## Caching

GitHub Pages uses CDN caching:

- Static files are cached
- Updates may take 1-2 minutes to propagate
- Force refresh with `?v=timestamp` if needed

## Directory Structure

```
didwebs.info/
├── sample-context-docs/     # JSON-LD contexts
│   └── ConditionalProof2022.jsonld
├── static/                   # Other static resources (optional)
│   ├── schemas/             # JSON schemas
│   ├── examples/            # Example files
│   └── data/                # Data files
└── docs/                     # Documentation (markdown)
```

## Testing Locally

Test static file serving locally:

```bash
# Start local server
./serve.sh

# Test JSON-LD context
curl http://localhost:3000/sample-context-docs/ConditionalProof2022.jsonld

# Check MIME type
curl -I http://localhost:3000/sample-context-docs/ConditionalProof2022.jsonld
```

## Production URLs

Once deployed, static resources are available at:

```
https://kentbull.github.io/didwebs.info/sample-context-docs/ConditionalProof2022.jsonld
```

These URLs can be used in:
- JSON-LD `@context` references
- Verifiable Credential contexts
- Schema references
- API documentation
- Code examples

## Notes

- **No Nginx needed**: GitHub Pages serves static files automatically
- **No special configuration**: Just place files in the repository
- **Docsify compatible**: Docsify ignores non-markdown files
- **CDN delivery**: Fast worldwide access via GitHub's CDN
- **HTTPS by default**: All files served over HTTPS
