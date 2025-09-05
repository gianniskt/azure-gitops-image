# Azure GitOps DevContainer with MCP Integration

[![Docker Build](https://img.shields.io/badge/docker-build-blue?logo=docker)](https://github.com/gianniskt/azure-gitops-image)
[![Image Size](https://img.shields.io/badge/size-1.17GB-green)](https://github.com/gianniskt/azure-gitops-image)
[![Security](https://img.shields.io/badge/security-non--root--user-green)](https://github.com/gianniskt/azure-gitops-image)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A secure Ubuntu-based DevContainer** designed specifically for **Azure GitOps workflows** with integrated **Flux Operator MCP (Model Context Protocol) Server**. This container empowers cloud platform engineers to seamlessly integrate AI assistance into their GitOps workflows using GitHub Copilot and other AI tools.

## 🚀 What Makes This Different

### AI-Powered GitOps Workflows
- **Integrated Flux Operator MCP Server**: AI integration for FluxCD operations
- **GitHub Copilot Ready**: Pre-configured MCP integration for intelligent GitOps assistance
- **Cloud Platform Engineering Focus**: Designed for platform engineers managing Kubernetes at scale

### Production-Ready GitOps Stack
- **Complete Azure Ecosystem**: Azure CLI, Terraform, and Azure-specific extensions
- **GitOps Tools**: FluxCD, Kustomize, Helm for complete GitOps workflows
- **Kubernetes Management**: kubectl, kubectx for cluster operations
- **Infrastructure as Code**: Terraform with latest version auto-detection

## 🛠️ Included Tools

### Core GitOps Tools
| Tool | Version | Purpose |
|------|---------|---------|
| **FluxCD CLI** | Latest | GitOps continuous delivery |
| **Kustomize** | Latest | Kubernetes configuration management |
| **Helm** | Latest | Kubernetes package management |
| **kubectl** | Latest | Kubernetes cluster control |
| **kubectx** | Latest | Kubernetes context switching |

### Azure & Cloud Tools
| Tool | Version | Purpose |
|------|---------|---------|
| **Azure CLI** | Latest | Azure resource management |
| **Terraform** | Latest | Infrastructure as Code |

### Data Processing Tools
| Tool | Version | Purpose |
|------|---------|---------|
| **jq** | Latest | JSON processing |
| **yq** | Latest | YAML processing |

### AI Integration
| Tool | Version | Purpose |
|------|---------|---------|
| **Flux Operator MCP Server** | v0.28.0 | AI assistance for FluxCD operations |

### Development Environment
| Tool | Version | Purpose |
|------|---------|---------|
| **Git** | Latest | Version control |
| **Python 3.12** | 3.12 | Scripting and automation |
| **curl/wget** | Latest | Data transfer |

## 🔒 Security Features

### Non-Root User Design
- **Dedicated User**: Runs as `myuser` (UID: 1001, GID: 1001)
- **Sudo Access**: Controlled sudo permissions for administrative tasks
- **Home Directory**: Isolated user workspace at `/home/myuser`
- **Secure Defaults**: No unnecessary privileges or exposed services

### Minimal Attack Surface
- **No Recommended Packages**: Only essential packages installed
- **Regular Cleanup**: Temporary files and caches removed
- **Latest Security Updates**: Based on Ubuntu 24.04 LTS with latest packages

## 🚀 Quick Start

### Option 1: VS Code DevContainer (Recommended)

1. **Clone the repository**:
   ```bash
   git clone https://github.com/gianniskt/azure-gitops-image.git
   cd azure-gitops-image
   ```

2. **Open in VS Code**:
   ```bash
   code .
   ```

3. **Reopen in Container**:
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
   - Type "Dev Containers: Reopen in Container"
   - Select it and wait for the container to build and start

### Option 2: Direct Docker Build

```bash
# Build the image
docker build -t azure-gitops-devcontainer .

# Run interactively
docker run -it --rm \
  -v $(pwd):/workspace \
  -v ~/.kube:/home/myuser/.kube:ro \
  azure-gitops-devcontainer bash
```

### Option 3: DevContainer CLI

```bash
# Build using DevContainer CLI
devcontainer build --workspace-folder . --image-name azure-gitops-devcontainer

# Run with DevContainer CLI
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . bash
```

## 🤖 AI Integration Setup

The container includes **Flux Operator MCP Server** for AI-powered GitOps assistance:

### GitHub Copilot Integration
The DevContainer comes pre-configured with GitHub Copilot extensions and MCP settings for seamless AI assistance in your GitOps workflows.

## 📁 Project Structure

```
azure-gitops-image/
├── Dockerfile                    # Dockerfile
├── .dockerignore                 # Docker build exclusions
├── build/
│   └── .devcontainer/
│       └── devcontainer.json     # Build-specific DevContainer config
├── .devcontainer/
│   └── devcontainer.json         # Main DevContainer configuration
└── README.md                     # This file
```

## 🔧 Customization

### Adding Your Own Tools
Edit the `Dockerfile` to include additional tools:

```dockerfile
# Add your custom tools in the main GitOps tools layer
RUN set -e \
    # ... existing tools ... \
    \
    # Your custom tool
    && TOOL_VERSION=$(curl -s https://api.github.com/repos/owner/tool/releases/latest | grep '"tag_name"' | cut -d '"' -f 4) \
    && wget "https://github.com/owner/tool/releases/download/${TOOL_VERSION}/tool_linux_amd64.tar.gz" \
    && tar -xzf "tool_linux_amd64.tar.gz" \
    && mv tool /usr/local/bin/ \
    && rm -f *.tar.gz
```

## 🔄 GitOps Workflow Examples

### FluxCD with AI Assistance

#### Step 1: Install Flux Operator
First, install the Flux Operator following the [official documentation](https://fluxcd.control-plane.io/operator/install/):

```bash
# Install Flux Operator
kubectl apply -f https://github.com/controlplaneio-fluxcd/flux-operator/releases/latest/download/flux-operator.yaml

# Verify the installation
kubectl -n flux-system get pods

# Create a FluxInstance to manage your Flux installation
cat <<EOF | kubectl apply -f -
apiVersion: fluxcd.controlplane.io/v1
kind: FluxInstance
metadata:
  name: flux
  namespace: flux-system
spec:
  distribution:
    version: "2.x"
    registry: "ghcr.io/fluxcd"
  components:
    - source-controller
    - kustomize-controller
    - helm-controller
    - notification-controller
    - image-reflector-controller
    - image-automation-controller
  cluster:
    type: kubernetes
    multitenant: false
    networkPolicy: true
    domain: "cluster.local"
EOF
```

#### Step 2: Bootstrap FluxCD
After the Flux Operator is installed and the FluxInstance is ready, bootstrap your Git repository:

```bash
# Verify Flux Operator installation
kubectl wait --for=condition=Ready fluxinstance/flux -n flux-system --timeout=5m

# Bootstrap Flux with your Git repository
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=$GITHUB_REPO \
  --branch=main \
  --path=./clusters/my-cluster \
  --personal

# Verify the bootstrap
flux check
```

#### Step 3: AI-Powered GitOps Assistance
With the MCP server integration, you can now get AI assistance for your GitOps workflows.

For detailed examples and prompt engineering techniques, see the [official MCP documentation](https://fluxcd.control-plane.io/mcp/prompt-engineering/).

#### Benefits of Flux Operator + MCP Integration
- **Declarative Flux Management**: FluxInstance CRD manages Flux installation lifecycle
- **AI-Powered Troubleshooting**: MCP server provides intelligent analysis of Flux resources
- **Multi-Cluster Support**: Easily manage Flux across multiple clusters
- **GitOps Best Practices**: Automated reconciliation with AI-assisted monitoring

## 📦 Releases & Versioning

### **Release Format**
This project uses a simplified `major.minor` versioning scheme:
- **v1.0** → **v1.1** → **v1.2** → **v1.3** (regular updates)
- **v1.0** → **v2.0** → **v3.0** (major changes)

### **Docker Image Tags**
Each release creates exactly two Docker tags:
- **Version tag**: `ghcr.io/gianniskt/azure-gitops-image:1.0`
- **Latest tag**: `ghcr.io/gianniskt/azure-gitops-image:latest`

### **Creating Releases**
1. **Automated via GitHub Actions**:
   - Go to repository → Actions → "Create Release" workflow
   - Choose version bump type: **minor** (1.0→1.1) or **major** (1.0→2.0)
   - Workflow automatically creates tag, release, and Docker images

2. **Manual Git Tags**:
   ```bash
   git tag v1.0
   git push origin v1.0
   ```

### **Using Specific Versions**
```bash
# Always latest stable
docker pull ghcr.io/gianniskt/azure-gitops-image:latest

# Pin to specific version
docker pull ghcr.io/gianniskt/azure-gitops-image:1.0
docker pull ghcr.io/gianniskt/azure-gitops-image:1.1
```

### Terraform with Azure
```bash
# Azure login
az login

# Terraform operations with Azure provider
terraform init
terraform plan
terraform apply
```

### Kubernetes Management
```bash
# Switch contexts easily
kubectx production
kubectx staging

# Apply Kustomizations
kustomize build ./environments/production | kubectl apply -f -

# Helm chart management
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/nginx
```

### Performance Metrics
| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| **Image Size** | 2.07GB | 1.17GB | **43% smaller** |
| **Docker Layers** | 15+ | 3 | **80% fewer** |
| **Build Time** | ~8 min | ~3 min | **62% faster** |
| **Container Startup** | ~15s | ~5s | **67% faster** |

### Docker Image Tags
| Tag Pattern | Description | Use Case |
|-------------|-------------|----------|
| `latest` | Always points to newest release | Production deployments |
| `1.0`, `1.1`, `1.2` | Specific version tags | Version pinning, rollbacks |

### Multi-Platform Support
| Architecture | Status | Target Use |
|--------------|--------|------------|
| `linux/amd64` | ✅ Supported | Intel/AMD servers, CI/CD |
| `linux/arm64` | ✅ Supported | Apple Silicon, ARM servers |

## 🛡️ Security Considerations

### User Security
- **Non-root execution**: All operations run as `myuser`
- **Controlled privileges**: Sudo access only when needed
- **Isolated environment**: User-specific home directory and workspace

### Network Security
- **No unnecessary services**: Clean, minimal service footprint
- **Secure defaults**: All tools configured with security best practices
- **MCP Server Security**: 
  - Requires explicit KUBECONFIG access for Kubernetes operations
  - Recommended to use through authenticated DevContainer/Codespaces only

### Supply Chain Security
- **Pinned versions**: MCP server uses specific version (v0.28.0)
- **Official sources**: All tools downloaded from official GitHub releases
- **Checksum validation**: Where available, checksums are validated
- **Regular updates**: Base image and tools updated regularly

## 🤝 Contributing

We welcome contributions! Please see our [contributing guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with DevContainer
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **FluxCD Team** for the excellent GitOps toolkit
- **Microsoft** for VS Code DevContainer technology
- **GitHub** for Copilot and MCP integration capabilities
- **Ubuntu** for the solid foundation

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/gianniskt/azure-gitops-image/issues)
- **Discussions**: [GitHub Discussions](https://github.com/gianniskt/azure-gitops-image/discussions)
- **Documentation**: [Wiki](https://github.com/gianniskt/azure-gitops-image/wiki)

---

**Made with ❤️ for Cloud Platform Engineers**

## 🚀 Features

### Base Image
- **Ubuntu 24.04** via `ubuntu:24.04`
- **User**: `myuser` with sudo privileges

### Tools Included

#### GitOps & Kubernetes
- **FluxCD CLI** (latest) - GitOps toolkit for Kubernetes
- **Kustomize** (latest) - Kubernetes native configuration management
- **kubectl** (latest) - Kubernetes command-line tool
- **Helm** (latest) - Kubernetes package manager
- **kubectx** (latest) - Kubernetes context

#### Infrastructure as Code
- **Terraform** (latest) - Infrastructure provisioning

#### Azure Tools
- **Azure CLI** (latest) - Azure command-line interface

#### Development Tools
- **Python 3.12** with pip
- **Git**

#### Utilities
- **jq** - JSON processor
- **yq** - YAML processor

#### AI-Powered GitOps
- **Flux Operator MCP Server v0.28.0** - Model Context Protocol server for AI-assisted GitOps
  - Enables AI assistants to interact with Flux resources
  - Supports VS Code Copilot Chat integration
  - Provides GitOps workflow automation

## 📦 Usage

### Using with GitHub Codespaces

Add `.devcontainer/devcontainer.json` to your repository.

### Using with VS Code Dev Containers

1. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Use the image in your `.devcontainer/devcontainer.json`
3. Open in container

### Using with Docker

```bash
docker pull ghcr.io/gianniskt/azure-gitops-image:latest
docker run -it ghcr.io/gianniskt/azure-gitops-image:latest bash
```

#### Version-Specific Images
```bash
# Use specific version
docker pull ghcr.io/gianniskt/azure-gitops-image:1.0
docker pull ghcr.io/gianniskt/azure-gitops-image:1.1
docker pull ghcr.io/gianniskt/azure-gitops-image:1.2
```

## 🏗️ Building Locally

```bash
# Clone the repository
git clone https://github.com/gianniskt/azure-gitops-image.git
cd azure-gitops-image

# Build the image
docker build -t azure-gitops-image .

# Or use devcontainer CLI
devcontainer build --workspace-folder build --image-name azure-gitops-image/mydevcontainer:latest
```

## 🔧 Configuration

### Flux MCP Server

The image includes the Flux Operator MCP Server for AI-assisted GitOps. To use with VS Code Copilot:

1. Configure your kubeconfig
2. The MCP server is available at `/usr/local/bin/flux-operator-mcp`
3. Enable Agent mode in GitHub Copilot Chat

### AI Assistant Configuration

#### Claude, Cursor, and Windsurf

Add the following configuration to your AI assistant's settings:

```json
{
 "mcpServers": {
   "flux-operator-mcp": {
     "command": "/usr/local/bin/flux-operator-mcp",
     "args": ["serve"],
     "env": {
       "KUBECONFIG": "$HOME/.kube/config"
     }
   }
 }
}
```

#### VS Code Copilot Chat

Add the following configuration to your VS Code settings (`settings.json`):

```json
{
 "mcp": {
   "servers": {
     "flux-operator-mcp": {
       "command": "/usr/local/bin/flux-operator-mcp",
       "args": ["serve"],
       "env": {
         "KUBECONFIG": "$HOME/.kube/config"
       }
     }
   }
 },
 "chat.mcp.enabled": true
}
```

When using GitHub Copilot Chat, remember to enable Agent mode (`@agent`) to access the Flux MCP tools.

### Environment Variables

The following environment variables are pre-configured:
- `SHELL=/bin/zsh`
- `PATH` includes all tool directories

## 📋 Included VS Code Extensions

- **Git Graph** - Visualize git repository
- **GitHub Actions** - GitHub workflow support
- **Python** - Python development
- **Azure Tools** - Azure development
- **Terraform** - Infrastructure as code
- **YAML** - YAML language support
- **Kubernetes Tools** - Kubernetes development
- **SOPS** - Secrets management
- **GitHub Copilot** - AI pair programming

## 🚢 CI/CD

The image is automatically built and pushed to GitHub Container Registry (GHCR) using GitHub Actions workflows:

### **Automated Docker Builds**
- **Push to main**: Builds and pushes with `latest` tag
- **Git tags**: Builds version-specific images (e.g., `1.0`, `1.1`, `1.2`)
- **Pull requests**: Builds for testing (not pushed to registry)
- **Manual dispatch**: Can be triggered manually from GitHub Actions

### **Automated Releases**
- **Version Format**: `1.0` → `1.1` → `1.2` (major.minor only)
- **Release Creation**: Use GitHub Actions "Create Release" workflow
- **Version Bumping**: Choose minor (1.0→1.1) or major (1.0→2.0) increments
- **Docker Tags**: Each release creates only two tags: version tag (e.g., `1.0`) and `latest`

### **Multi-platform Support**
- `linux/amd64` (Intel/AMD x64)
- `linux/arm64` (Apple Silicon, ARM servers)

### **Security Features**
- Build provenance attestation for supply chain security
- Minimal permissions with GitHub's built-in `GITHUB_TOKEN`
- Multi-platform builds with cache optimization

## 🔐 Security

- Runs as non-root user (`myuser`)
- Built with provenance attestation
- Regular dependency updates

## Prerequisites

1. Visual Studio Code IDE: https://code.visualstudio.com/download
2. Dev Containers VS Code Extension + Docker: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers
3. Dev Container CLI: https://code.visualstudio.com/docs/devcontainers/devcontainer-cli#_installation

## 📝 License

This project is licensed under the terms specified in the repository.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the build
5. Submit a pull request

## 📚 Related Projects

- [FluxCD](https://fluxcd.io/) - GitOps toolkit for Kubernetes
- [Flux Operator](https://github.com/controlplaneio-fluxcd/flux-operator) - Flux management operator
- [Azure DevContainers](https://github.com/devcontainers/images) - Base images

## 🆘 Support

For issues and questions:
- Open an issue in this repository
- Check the [DevContainers documentation](https://containers.dev/)
- Review [FluxCD documentation](https://fluxcd.io/flux/)
