#!/bin/bash

ARCH=$(uname -m)
OS=$(uname -s | awk '{print tolower($0)}')
echo "Do you want to forcibly install new versions ? [y/n]"
read FORCE

download_go(){
  read -p "Enter the Go version you want to install : " GoVersion
  curl --fail-with-body --progress-bar -Lo "$HOME/go$GoVersion.$OS-$ARCH.tar.gz" --url "https://go.dev/dl/go$GoVersion.$OS-$ARCH.tar.gz"
  sudo tar -C /usr/local -xzf "$HOME/go$GoVersion.$OS-$ARCH.tar.gz"
  rm -rf "$HOME/go$GoVersion.$OS-$ARCH.tar.gz"
}

download_helm(){
  read -p "Enter the helm version you want to install : " HelmVersion
  curl --fail-with-body --progress-bar -Lo "$HOME/helm-v$HelmVersion-$OS-$ARCH.tar.gz" --url "https://get.helm.sh/helm-v$HelmVersion-$OS-$ARCH.tar.gz"
  sudo tar -C /usr/local -xzf "$HOME/helm-v$HelmVersion-$OS-$ARCH.tar.gz"
  rm -rf "$HOME/helm-v$HelmVersion-$OS-$ARCH.tar.gz"
}

download_kubectl(){
  read -p "Enter the kubectl version you want to install : " KubectlVersion
  curl --fail-with-body --progress-bar -Lo "$HOME/kubectl" --url "https://dl.k8s.io/release/v$KubectlVersion/bin/$OS/$ARCH/kubectl"
  chmod +x "$HOME/kubectl"
  sudo mv "$HOME/kubectl" /usr/local/bin/kubectl
  sudo chown root: /usr/local/bin/kubectl
}

download_kind(){
  read -p "Enter the kind version you want to install : " KindVersion
  sudo rm -f /usr/local/bin/kind
  go clean -modcache
  go install "sigs.k8s.io/kind@v$KindVersion"
  echo "You may have to add kind to your PATH variable if command -v kind returns 'command not found'"
}

install_golang(){
  if ! command -v go > /dev/null; then
    download_go
  elif [ $FORCE == "y" ]; then
    GO_ROOT=$(go env GOROOT 2>/dev/null)
    if [ -n "$GO_ROOT" ]; then
      echo "Detected Go root: $GO_ROOT"
      sudo rm -rf "$GO_ROOT"
      echo "Removed Go installation at $GO_ROOT"
    else
      echo "Go not installed or GOROOT not set"
    fi
    download_go
  fi
}


install_helm(){
  if ! command -v helm > /dev/null; then
    download_helm
  elif [ $FORCE == "y" ]; then
    HELM_BINARY=$(command -v helm 2>/dev/null)
    if [ -n "$HELM_BINARY" ]; then
      echo "Detected Helm binary: $HELM_BINARY"
      sudo rm -f "$HELM_BINARY"
      echo "Removed Helm installation at $HELM_BINARY"
    else
      echo "Helm not installed"
    fi
    download_helm
  fi
}

install_kubectl(){
  if ! command -v kubectl > /dev/null; then
    download_kubectl
  elif [ $FORCE == "y" ]; then
    KUBECTL_BINARY=$(command -v kubectl 2>/dev/null)
    if [ -n "$KUBECTL_BINARY" ]; then
      echo "Detected Kubectl binary: $KUBECTL_BINARY"
      sudo rm -f "$KUBECTL_BINARY"
      echo "Removed Kubectl installation at $KUBECTL_BINARY"
    else
      echo "Kubectl not installed"
    fi
    download_kubectl
  fi
}

install_kind(){
  if ! command -v kind > /dev/null; then
    download_kind
  elif [ $FORCE == "y" ]; then
    KIND_BINARY=$(command -v kind 2>/dev/null)
    if [ -n "$KIND_BINARY" ]; then
      echo "Detected Kind binary: $KIND_BINARY"
      sudo rm -f "$KIND_BINARY"
      echo "Removed Kind installation at $KIND_BINARY"
    else
      echo "Kind not installed"
    fi
    download_kind
  fi
}

install_golang
install_kubectl
install_helm
install_kind
