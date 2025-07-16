# gossy-workstations-image

このリポジトリは、Google Cloud Workstations で使用するためのカスタムコンテナイメージをビルドします。
開発に必要なツールやVSCode拡張機能がプリインストールされており、すぐに開発を開始できる環境を提供することを目的としています。

## 概要

`Dockerfile` をもとに、Google Cloud Build を通じてコンテナイメージがビルドされ、Artifact Registry にプッシュされます。

## プリインストールされている主なツール

*   Terraform
*   Python 3 (venv, uv, agent-starter-pack)
*   Google Gemini CLI (`@google/gemini-cli`)
*   その他: `make`, `jq`, `curl` など

## プリインストールされているVSCode拡張機能

*   Python (ms-python.python)
*   Jupyter (ms-toolsai.jupyter)
*   HashiCorp Terraform (hashicorp.terraform)

## ビルド方法

このリポジトリをGoogle Cloud Source Repositoriesにミラーリングし、Cloud Build トリガーを設定することで、コードの変更時に自動でイメージのビルドとプッシュが実行されます。

手動でビルドを実行する場合は、リポジトリのルートで以下のコマンドを実行します。

```sh
gcloud builds submit . --config cloudbuild.yaml
```
`cloudbuild.yaml` 内の置換変数は、必要に応じて調整してください。

## 利用方法

ビルドされたイメージは、Cloud Workstations のワークステーション構成でカスタムコンテナイメージとして指定することで利用できます。
