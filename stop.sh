#!/usr/bin/env sh
set -e

main() {
  stop_minikube
}

stop_minikube() {
  STATUS="$(minikube status -f '{{and (eq .Kubelet "Running") (eq .APIServer "Running") (eq .Kubeconfig "Configured")}}' || true)"
  if echo "$STATUS" | grep -qF 'true'; then
    echo 'info: stoping minikube'
    minikube stop
  else
    echo 'info: it is already down'
  fi
}

main
