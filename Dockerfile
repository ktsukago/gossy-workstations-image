FROM asia-northeast1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

# Install system dependencies and Terraform
ENV DEBIAN_FRONTEND=noninteractive

# =================================================================================
#【最終修正】
# 1. ベースイメージに含まれる、壊れたYarnのリポジトリ設定を最初に削除します。
# 2. その後、正しい設定でYarnとHashiCorpのリポジトリを再追加します。
# =================================================================================
RUN rm -f /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y ca-certificates curl gnupg \
    && mkdir -p /etc/apt/keyrings \
    # Add Yarn GPG key using the recommended method
    && curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarnkey.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list > /dev/null \
    # Add HashiCorp GPG key using the recommended method
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /etc/apt/keyrings/hashicorp.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list > /dev/null \
    # Update package lists again and install all required packages
    && apt-get update && apt-get install -y \
    python3-venv \
    make \
    jq \
    software-properties-common \
    asciinema \
    terraform \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a global virtual environment and install Python packages
RUN python3 -m venv /opt/global-venv \
    && /opt/global-venv/bin/pip install --no-cache-dir uv \
    && /opt/global-venv/bin/pip install --no-cache-dir --upgrade agent-starter-pack

# install gemini cli
RUN npm install -g @google/gemini-cli

# Activate the global venv for all users by default and install project packages
ENV VIRTUAL_ENV="/opt/global-venv"
# Prepend venv's bin to the PATH
ENV PATH="/opt/global-venv/bin:${PATH}"

# Install VSCode Extensions
RUN mkdir -p /tmp/extensions \
    && cd /tmp/extensions \
    # Python Extension
    && wget -q https://open-vsx.org/api/ms-python/python/2025.4.0/file/ms-python.python-2025.4.0.vsix \
    && unzip -q ms-python.python-2025.4.0.vsix "extension/*" \
    && mv extension /opt/code-oss/extensions/ms-python \
    && rm -rf extension ms-python.python-2025.4.0.vsix \
    # Jupyter Extension
    && wget -q https://open-vsx.org/api/ms-toolsai/jupyter/2025.5.0/file/ms-toolsai.jupyter-2025.5.0.vsix \
    && unzip -q ms-toolsai.jupyter-2025.5.0.vsix "extension/*" \
    && mv extension /opt/code-oss/extensions/ms-toolsai \
    && rm -rf extension ms-toolsai.jupyter-2025.5.0.vsix \
    # Terraform Extension
    && wget https://open-vsx.org/api/hashicorp/terraform/linux-x64/2.34.5/file/hashicorp.terraform-2.34.5@linux-x64.vsix \
    && unzip hashicorp.terraform-2.34.5@linux-x64.vsix "extension/*" \
    && mv extension /opt/code-oss/extensions/hashicorp-terraform \
    && rm -rf extension hashicorp.terraform-2.34.5@linux-x64.vsix \
    && cd / \
    && rmdir /tmp/extensions
