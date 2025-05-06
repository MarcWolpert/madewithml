#!/usr/bin/env bash
set -euo pipefail

# ---------- 1. Load & export .env ----------
set -a
source "$(dirname "$0")/.env"
set +a

# ---------- 2. Verify mandatory vars ----------
: "${ANYSCALE_CLI_TOKEN:?Set in .env}"
: "${PROJECT_NAME:?Set in .env}"
: "${CLUSTER_ENV_NAME:?Set in .env}"
: "${CLUSTER_COMPUTE_NAME:?Set in .env}"

# ---------- 3. Authenticate ----------
anyscale login --token "$ANYSCALE_CLI_TOKEN" --host "$ANYSCALE_HOST" >/dev/null

# ---------- 4. Ensure project exists & select it ----------
if ! anyscale project get -n "$PROJECT_NAME" >/dev/null 2>&1; then
  anyscale project create --name "$PROJECT_NAME" >/dev/null
fi
export ANYSCALE_PROJECT_NAME="$PROJECT_NAME"

# ---------- 5. Build cluster environment if needed ----------
if ! anyscale cluster-env get -n "$CLUSTER_ENV_NAME" >/dev/null 2>&1; then
  anyscale cluster-env build deploy/cluster_env.yaml --name "$CLUSTER_ENV_NAME"
fi

# ---------- 6. Register compute config if needed ----------
if ! anyscale cluster-compute get -n "$CLUSTER_COMPUTE_NAME" >/dev/null 2>&1; then
  anyscale cluster-compute create deploy/cluster_compute.yaml --name "$CLUSTER_COMPUTE_NAME"
fi

echo "✅  All Anyscale resources are ready in project: $PROJECT_NAME"
