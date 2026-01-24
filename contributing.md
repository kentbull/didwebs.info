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

## Contribution Process

### 1. Find or Create an Issue

Before starting work:

1. Check existing issues for similar work
2. Create a new issue if needed
3. Discuss your approach
4. Get feedback from maintainers

### 2. Fork and Branch

```bash
# Fork the repository on GitHub
git clone https://github.com/YOUR_USERNAME/REPO_NAME.git
cd REPO_NAME
git checkout -b feature/your-feature-name
```

### 3. Make Changes

- Follow the project's coding standards
- Write clear commit messages
- Add tests for new features
- Update documentation

### 4. Test Your Changes

**For Implementation:**

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=src --cov-report=html

# Run linting
ruff check src tests
```

**For Specification:**

```bash
# Build and preview
npm run edit
```

### 5. Submit a Pull Request

1. Push your branch to your fork
2. Create a pull request
3. Fill out the PR template
4. Link related issues
5. Wait for review

### 6. Address Feedback

- Respond to review comments
- Make requested changes
- Update your PR
- Be patient and respectful

## Coding Standards

### Python (Reference Implementation)

- **Style**: Follow PEP 8
- **Linting**: Use `ruff`
- **Type Hints**: Use type annotations
- **Docstrings**: Use Google-style docstrings
- **Testing**: Write pytest tests with good coverage

**Example:**

```python
def resolve_did_webs(did: str, verify: bool = True) -> dict:
    """Resolve a did:webs DID to a DID document.
    
    Args:
        did: The did:webs DID to resolve
        verify: Whether to verify the KERI event stream
        
    Returns:
        The resolved DID document
        
    Raises:
        ValueError: If the DID format is invalid
        ResolutionError: If resolution fails
    """
    # Implementation
    pass
```

### Specification (Markdown)

- **Format**: Use Spec-Up markdown format
- **References**: Use proper reference syntax
- **Examples**: Include clear examples
- **Normative Language**: Use RFC 2119 keywords (MUST, SHOULD, etc.)

**Example:**

```markdown
## Resolution

1. A resolver MUST fetch the `did.json` file from the web location.
2. A resolver MUST fetch the `keri.cesr` file from the web location.
3. A resolver SHOULD verify the KERI event stream.
```

## Commit Message Guidelines

Write clear, descriptive commit messages:

**Format:**

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `test`: Test changes
- `refactor`: Code refactoring
- `style`: Code style changes
- `chore`: Build/tooling changes

**Examples:**

```
feat(resolver): add support for DID parameters

Implements DID parameter handling for version-specific resolution.

Closes #123
```

```
fix(verification): correct witness receipt validation

The witness receipt validation was failing for multi-sig witnesses.
This fix properly handles the threshold signature verification.

Fixes #456
```

## Testing Guidelines

### Unit Tests

- Test individual functions and classes
- Mock external dependencies
- Aim for high coverage (>80%)
- Test edge cases and error conditions

**Example:**

```python
def test_did_to_https_transformation():
    """Test DID to HTTPS URL transformation."""
    did = "did:webs:example.com:alice:EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP"
    expected = "https://example.com/alice/EKYGGh-FtAphGmSZbsuBs_t4qpsjYJ2ZqvMKluq9OxmP/did.json"
    
    result = did_to_https(did)
    
    assert result == expected
```

### Integration Tests

- Test complete workflows
- Use real KERI infrastructure (witnesses, etc.)
- Test against live deployments
- Verify interoperability

### Test Documentation

- Document test setup requirements
- Explain complex test scenarios
- Include instructions for running tests

## Documentation Guidelines

### Writing Style

- **Clear**: Use simple, direct language
- **Concise**: Avoid unnecessary words
- **Consistent**: Use consistent terminology
- **Complete**: Include all necessary information
- **Correct**: Ensure technical accuracy

### Structure

- **Overview**: Start with a high-level overview
- **Details**: Provide detailed information
- **Examples**: Include practical examples
- **References**: Link to related documentation

### Code Examples

- Use realistic examples
- Include complete, runnable code
- Add comments for clarity
- Show expected output

## Community Guidelines

### Code of Conduct

Be respectful and professional:

- **Respectful**: Treat others with respect
- **Inclusive**: Welcome diverse perspectives
- **Constructive**: Provide constructive feedback
- **Professional**: Maintain professional conduct

### Communication

- **GitHub Issues**: For bugs and feature requests
- **Pull Requests**: For code contributions
- **Discussions**: For questions and ideas
- **Email**: For private matters

### Response Times

- Maintainers will respond within 1-2 weeks
- Complex issues may take longer
- Be patient and understanding

## Recognition

Contributors are recognized in:

- **Specification**: Acknowledgements section
- **Repository**: CONTRIBUTORS.md file
- **Releases**: Release notes

## Legal

### Licensing

By contributing, you agree that your contributions will be licensed under:

- **Specification**: Trust Over IP Foundation licensing
- **Implementation**: Apache 2.0 License

### Copyright

- Retain your copyright
- Grant necessary licenses for use
- Follow project licensing requirements

### Contributor License Agreement

Some projects may require a CLA:

- Read the CLA carefully
- Sign electronically
- Keep a copy for your records

## Resources

### Documentation

- **Specification**: [tswg-did-method-webs-specification](https://github.com/trustoverip/tswg-did-method-webs-specification)
- **Implementation**: [did-webs-resolver](https://github.com/GLEIF-IT/did-webs-resolver)
- **KERI**: [keri.one](https://keri.one)

### Community

- **Trust Over IP**: [trustoverip.org](https://trustoverip.org/)
- **GLEIF**: [gleif.org](https://www.gleif.org/)
- **WebOfTrust**: [github.com/WebOfTrust](https://github.com/WebOfTrust)

### Tools

- **Spec-Up**: [github.com/decentralized-identity/spec-up](https://github.com/decentralized-identity/spec-up)
- **KERIpy**: [github.com/WebOfTrust/keripy](https://github.com/WebOfTrust/keripy)
- **Universal Resolver**: [dev.uniresolver.io](https://dev.uniresolver.io/)

## Questions?

If you have questions about contributing:

1. Check this guide
2. Review existing issues and PRs
3. Ask in a GitHub issue
4. Contact the maintainers

Thank you for contributing to `did:webs`! Your contributions help make decentralized identity more secure and accessible.
