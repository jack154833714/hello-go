#!/usr/bin/env bash
set -euo pipefail

projectDir="/root/projects/hello-go"
serviceName="hello-go"
healthUrlLocal="http://127.0.0.1:8080/health"
healthUrlPublic="https://orangepi.kanyarat.xyz/health"

echo "==> [1/6] cd ${projectDir}"
cd "${projectDir}"

echo "==> [2/6] git pull"
git pull --rebase

echo "==> [3/6] docker compose build + up"
docker compose up -d --build

echo "==> [4/6] status"
docker compose ps

echo "==> [5/6] logs (last 50 lines)"
docker compose logs --tail=50 "${serviceName}" || true

echo "==> [6/6] health check"
echo -n "Local:  "
curl -fsS "${healthUrlLocal}" && echo
echo -n "Public: "
curl -fsS "${healthUrlPublic}" && echo

echo "✅ Deploy done."
