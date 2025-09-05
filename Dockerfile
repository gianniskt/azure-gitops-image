# Ubuntu Azure GitOps DevContainer with MCP integration
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

# Single layer for system setup and user creation
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    git \
    sudo \
    python3.12 \
    python3-pip \
    gnupg \
    lsb-release \
    unzip \
    jq \
    && groupadd --gid 1001 myuser \
    && useradd --uid 1001 --gid myuser --shell /bin/bash --create-home myuser \
    && echo myuser ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/myuser \
    && chmod 0440 /etc/sudoers.d/myuser \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install Azure CLI with platform-specific handling and optimizations
RUN set -e \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release \
    && ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then \
        # Standard installation for amd64
        curl -sLS https://packages.microsoft.com/keys/microsoft.asc | \
            gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg \
        && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
            tee /etc/apt/sources.list.d/azure-cli.list \
        && apt-get update \
        && apt-get install -y --no-install-recommends azure-cli; \
    else \
        # Skip Azure CLI for ARM64 to reduce build time - can be installed at runtime
        echo "Azure CLI installation skipped for ARM64 - install manually if needed" \
        && echo '#!/bin/bash' > /usr/local/bin/az \
        && echo 'echo "Azure CLI not installed in ARM64 image - run: curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"' >> /usr/local/bin/az \
        && chmod +x /usr/local/bin/az; \
    fi \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install all GitOps tools in single layer
RUN set -e \
    # kubectl
    && KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt) \
    && curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl && mv kubectl /usr/local/bin/ \
    \
    # Helm
    && HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep '"tag_name"' | cut -d '"' -f 4) \
    && wget "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" \
    && tar -xzf "helm-${HELM_VERSION}-linux-amd64.tar.gz" \
    && mv linux-amd64/helm /usr/local/bin/ \
    && rm -rf linux-amd64 *.tar.gz \
    \
    # Terraform
    && TERRAFORM_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep '"tag_name"' | cut -d '"' -f 4 | tr -d 'v') \
    && wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && mv terraform /usr/local/bin/ \
    && rm -f *.zip \
    \
    # FluxCD CLI
    && FLUX_VERSION=$(curl -s https://api.github.com/repos/fluxcd/flux2/releases/latest | grep '"tag_name"' | cut -d '"' -f 4) \
    && wget "https://github.com/fluxcd/flux2/releases/download/${FLUX_VERSION}/flux_${FLUX_VERSION#v}_linux_amd64.tar.gz" \
    && tar -xzf "flux_${FLUX_VERSION#v}_linux_amd64.tar.gz" \
    && mv flux /usr/local/bin/ \
    && rm -f *.tar.gz \
    \
    # Kustomize
    && curl -L "$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest | grep -o -E -i -m 1 "https://.+?/kustomize_.+?_linux_amd64.tar.gz")" > kustomize.tar.gz \
    && tar -xzf kustomize.tar.gz kustomize \
    && mv kustomize /usr/local/bin/ \
    && rm kustomize.tar.gz \
    \
    # yq
    && YQ_VERSION=$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | grep '"tag_name"' | cut -d '"' -f 4) \
    && wget "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" \
    && mv yq_linux_amd64 /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq \
    \
    # kubectx
    && KUBECTX_VERSION=$(curl -s https://api.github.com/repos/ahmetb/kubectx/releases/latest | grep '"tag_name"' | cut -d '"' -f 4) \
    && wget "https://github.com/ahmetb/kubectx/releases/download/${KUBECTX_VERSION}/kubectx_${KUBECTX_VERSION}_linux_x86_64.tar.gz" \
    && tar -xzf "kubectx_${KUBECTX_VERSION}_linux_x86_64.tar.gz" \
    && mv kubectx /usr/local/bin/ \
    && rm -f *.tar.gz \
    \
    # Flux Operator MCP Server
    && wget https://github.com/controlplaneio-fluxcd/flux-operator/releases/download/v0.28.0/flux-operator-mcp_0.28.0_linux_amd64.tar.gz \
    && tar -xzf flux-operator-mcp_0.28.0_linux_amd64.tar.gz \
    && mv flux-operator-mcp /usr/local/bin/ \
    && rm -f *.tar.gz \
    \
    # Final cleanup
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache

# Set the user to myuser
USER myuser

# Set the working directory
WORKDIR /home/myuser

# Set metadata labels
LABEL org.opencontainers.image.title="Ubuntu Azure GitOps DevContainer with MCP"
LABEL org.opencontainers.image.description="Ubuntu DevContainer for Azure GitOps workflows with FluxCD MCP integration"
LABEL org.opencontainers.image.url="https://github.com/gianniskt/azure-gitops-image"
LABEL org.opencontainers.image.source="https://github.com/gianniskt/azure-gitops-image"
LABEL org.opencontainers.image.vendor="gianniskt"
LABEL org.opencontainers.image.licenses="MIT"