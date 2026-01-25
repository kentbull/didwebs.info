# [https://didwebs.info/](https://didwebs.info/)

Documentation site for the `did:webs` DID Method.


## About

`did:webs` is a DID method that combines the simplicity of `did:web` with the security of KERI (Key Event Receipt Infrastructure). This site provides comprehensive documentation including:

- Specification overview and core characteristics
- Implementation guides and tutorials
- Working examples and deployments
- FAQ and troubleshooting

## Quick Links

- 📖 [Introduction](https://didwebs.info/)
- 🚀 [Quick Start](https://didwebs.info/#/quickstart)
- 📋 [Specification](https://didwebs.info/#/specification)
- 💻 [Implementation Guide](https://didwebs.info/#/implementation/getting-started)
- 🌐 [Deployments](https://didwebs.info/#/deployments)

## Local Development

### Prerequisites

- Python 3.x (for local server)
- Or any static file server

### Run Locally

```bash
# Clone the repository
git clone git@github.com:kentbull/didwebs.info.git
cd didwebs.info

# Start local server
./serve.sh

# Or manually with Python
python3 -m http.server 3000

# Visit http://localhost:3000
```

## Contributing

Contributions are welcome! 

### Adding Content

1. Create a new `.md` file
2. Add entry to `_sidebar.md`
3. Test locally
4. Submit PR

### Updating Examples

Update working examples in:
- `deployments.md` - Deployment details
- `quickstart.md` - Quick start examples
- `examples.md` - Code examples


## License

Documentation is provided under the same license as the did:webs specification.

See the [Trust Over IP Foundation](https://trustoverip.org/) governance policies.


## Acknowledgments

- Trust Over IP Foundation - Specification development
- GLEIF - Reference implementation and testnet
- WebOfTrust - KERI protocol
- Docsify - Documentation framework

---

