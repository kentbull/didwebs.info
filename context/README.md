# Static Resources

This directory contains static JSON-LD context files and other resources that are served alongside the documentation.

## Available Resources

### JSON-LD Contexts

#### ConditionalProof2022.jsonld

A JSON-LD context for Conditional Proof 2022.

**Access URLs:**

- **Local**: http://localhost:3000/context/ConditionalProof2022.jsonld.txt
- **GitHub Pages**: https://didwebs.info/context/ConditionalProof2022.jsonld.txt

**Usage in code:**

```json
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
    "https://didwebs.info/context/ConditionalProof2022.jsonld"
  ],
  "type": ["VerifiableCredential"],
  ...
}
```

**Direct download:**

```bash
# Download the context file
curl -O https://didwebs.info/context/ConditionalProof2022.jsonld

# Or with wget
wget https://didwebs.info/context/ConditionalProof2022.jsonld
```

## Adding New Resources

To add new static resources:

1. **Place files in appropriate directory**:
   ```bash
   # For JSON-LD contexts
   cp my-context.jsonld context/
   
   # For schemas
   mkdir -p static/schemas
   cp my-schema.json static/schemas/
   ```

2. **Commit and push**:
   ```bash
   git add context/
   git commit -m "Add new context file"
   git push origin main
   ```

3. **Access via URL**:
   ```
   https://didwebs.info/context/my-context.jsonld
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
├── context/     # JSON-LD contexts
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
curl http://localhost:3000/context/ConditionalProof2022.jsonld

# Check MIME type
curl -I http://localhost:3000/context/ConditionalProof2022.jsonld
```

## Production URLs

Once deployed, static resources are available at:

```
https://didwebs.info/context/ConditionalProof2022.jsonld
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
