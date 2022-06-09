#!/usr/bin/env sh
set -e

IMAGE='juice:1.22.0'
ENVIRONMENT='development'
NAMESPACE="$(echo "$ENVIRONMENT" | tr '[:upper:]' '[:lower:]')"

main() {
  start_minikube
  build_image
  helm_upgrade
  check_curl
}

start_minikube() {
  STATUS="$(minikube status -f '{{and (eq .Kubelet "Running") (eq .APIServer "Running") (eq .Kubeconfig "Configured")}}' || true)"
  if ! echo "$STATUS" | grep -qF 'true'; then
    echo 'info: starting minikube'
    minikube start
    echo 'info: there is a list of nodes'
    kubectl get no -o wide
  fi
}

build_image() {
  echo 'info: building the image'
  docker build -t "$IMAGE" images/juice
  echo 'info: loading the image to minikube'
  minikube image load "$IMAGE"
}

helm_upgrade() {
  helm upgrade --install \
    --create-namespace \
    --namespace "$ENVIRONMENT" \
    --values "environment/${ENVIRONMENT}/values.yaml" \
    --set image.repository="$(echo "$IMAGE" | cut -d: -f1)" \
    --set image.tag="$(echo "$IMAGE" | cut -d: -f2-)" \
    lemon-juice charts/lemon
}

check_curl() {
  URL="$(minikube service list -n "$NAMESPACE" | grep -oE 'http://[^ ]+')"
  TRY=10
  while [ $TRY -gt 0 ]; do
    if curl -sSD- "$URL"; then
      echo "info: service is reachable, check it in browser at $URL"
      break
    fi
    TRY=$((TRY-1))
    sleep 1
  done
  if [ $TRY -eq 0 ]; then
    echo 'error: failed waiting for the service to be come reachable'
  fi
}

main 
