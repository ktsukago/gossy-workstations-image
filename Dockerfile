FROM asia-northeast1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

# Install system dependencies and Terraform
ENV DEBIAN_FRONTEND=noninteractive

# =================================================================================
#【最終修正】
# 1. ベースイメージに含まれる、壊れたYarnのリポジトリ設定を最初に削除します。
# 2. その後、正しい設定でYarnとHashiCorpのリポジトリを再追加します。
# =================================================================================
RUN rm -f /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y \
    python3-venv \
    make \
    jq \
    terraform \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a global virtual environment and install Python packages
RUN python3 -m venv /opt/global-venv \
    && /opt/global-venv/bin/pip install --no-cache-dir uv \
    && /opt/global-venv/bin/pip install --no-cache-dir --upgrade agent-starter-pack

# Activate the global venv for all users by default and install project packages
ENV VIRTUAL_ENV="/opt/global-venv"
# Prepend venv's bin to the PATH
ENV PATH="/opt/global-venv/bin:${PATH}"

    && cd / \
    && rmdir /tmp/extensions
