# Azure GitOps DevContainer with MCP Integration

[![Docker Build](https://img.shields.io/badge/docker-build-blue?logo=docker)](https://github.com/gianniskt/azure-gitops-image)
[![Security](https://img.shields.io/badge/security-non--root--user-green)](https://github.com/gianniskt/azure-gitops-image)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A secure Ubuntu-based DevContainer designed specifically for **Azure GitOps workflows** with integrated **Flux Operator MCP (Model Context Protocol) Server**. This container empowers cloud platform engineers to seamlessly integrate AI assistance into their GitOps workflows using GitHub Copilot and other AI tools.

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

## Prerequisites

1. Visual Studio Code IDE: https://code.visualstudio.com/download
2. Dev Containers VS Code Extension + Docker: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers
3. Dev Container CLI: https://code.visualstudio.com/docs/devcontainers/devcontainer-cli#_installation

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

### Option 2: Use Pre-built Image with Docker

```bash
# Pull and run latest version
docker pull ghcr.io/gianniskt/azure-gitops-image:latest
docker run -it --rm \
  -v $(pwd):/workspace \
  -v ~/.kube:/home/myuser/.kube \
  ghcr.io/gianniskt/azure-gitops-image:latest bash

# Use specific version
docker pull ghcr.io/gianniskt/azure-gitops-image:1.0
docker run -it --rm \
  -v $(pwd):/workspace \
  -v ~/.kube:/home/myuser/.kube \
  ghcr.io/gianniskt/azure-gitops-image:1.0 bash
```

### Option 3: Build Locally

```bash
# Clone and build the image
git clone https://github.com/gianniskt/azure-gitops-image.git
cd azure-gitops-image

# Build the image
docker build -t azure-gitops-devcontainer .

# Run interactively
docker run -it --rm \
  -v $(pwd):/workspace \
  -v ~/.kube:/home/myuser/.kube \
  azure-gitops-devcontainer bash
```

### Option 4: DevContainer CLI

```bash
# Build using DevContainer CLI
devcontainer build --workspace-folder . --image-name azure-gitops-devcontainer

# Run with DevContainer CLI
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . bash
```

### Option 5: GitHub Codespaces

Add `.devcontainer/devcontainer.json` to your repository and open in GitHub Codespaces for instant cloud development.

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

## 🚢 CI/CD

The image is automatically built and pushed to GitHub Container Registry (GHCR) after applying a Release Version.

## 🔒 Security Features

### Non-Root User Design
- **Dedicated User**: Runs as `myuser` (UID: 1001, GID: 1001)
- **Sudo Access**: Controlled sudo permissions for administrative tasks
- **Home Directory**: Isolated user workspace at `/home/myuser`
- **Secure Defaults**: No unnecessary privileges or exposed services

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

##  Configuration

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

## 📚 Related Projects

- [FluxCD](https://fluxcd.io/) - GitOps toolkit for Kubernetes
- [Flux Operator](https://github.com/controlplaneio-fluxcd/flux-operator) - Flux management operator
- [Azure DevContainers](https://github.com/devcontainers/images) - Base images

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

## 🆘 Support

For issues and questions:
- Open an issue in this repository
- Check the [DevContainers documentation](https://containers.dev/)
- Review [FluxCD documentation](https://fluxcd.io/flux/)
