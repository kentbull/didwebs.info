# Contributing

Thank you for your interest in contributing to `did:webs`! This document provides guidelines for contributing to the specification, implementations, and documentation.

## Ways to Contribute

There are many ways to contribute to the `did:webs` ecosystem:

### 1. Specification Development

Help improve the `did:webs` specification:

- Review and provide feedback on the specification
- Propose enhancements or clarifications
- Report ambiguities or errors
- Contribute use cases and examples

**Repository**: [tswg-did-method-webs-specification](https://github.com/trustoverip/tswg-did-method-webs-specification)

### 2. Reference Implementation

Contribute to the Python reference implementation:

- Fix bugs
- Add features
- Improve performance
- Enhance documentation
- Write tests

**Repository**: [did-webs-resolver](https://github.com/GLEIF-IT/did-webs-resolver)

### 3. Documentation

Help improve documentation:

- Fix typos and errors
- Add examples and tutorials
- Improve clarity
- Translate documentation
- Create video tutorials

**Repository**: This site's documentation

### 4. Testing

Help test `did:webs`:

- Test the reference implementation
- Report bugs
- Create test vectors
- Validate against the specification
- Test interoperability

### 5. Community Support

Help others in the community:

- Answer questions on GitHub
- Help troubleshoot issues
- Share your experiences
- Write blog posts
- Give presentations

### 6. New Implementations

Create implementations in other languages:

- JavaScript/TypeScript
- Rust
- Go
- Java
- Others

## Getting Started

See the [getting started guide](implementation/getting-started.md) or the [quickstart](quickstart.md).

### Prerequisites

Before contributing, familiarize yourself with:

- **W3C DID Core**: [https://www.w3.org/TR/did-core/](https://www.w3.org/TR/did-core/)
- **KERI**: [https://keri.one](https://keri.one)
- **did:webs Specification**: [Specification](specification.md)
- **Reference Implementation**: [did-webs-resolver](https://github.com/GLEIF-IT/did-webs-resolver)

### Setting Up Your Environment

**For Specification Work:**

```bash
git clone https://github.com/trustoverip/tswg-did-method-webs-specification.git
cd tswg-did-method-webs-specification
npm install
npm run edit
```

**For Implementation Work:**

```bash
git clone https://github.com/GLEIF-IT/did-webs-resolver.git
cd did-webs-resolver
uv lock
uv sync
source .venv/bin/activate
pytest
```

## Questions?

If you have questions about contributing:

1. Check this guide
2. Review existing issues and PRs
3. Ask in a GitHub issue
4. Contact the maintainers

Thank you for contributing to `did:webs`! Your contributions help make decentralized identity more secure and accessible.
