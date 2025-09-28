#!/bin/bash

ARCH=$(uname -m)
OS=$(uname -s | awk '{print tolower($0)}')
echo "Do you want to forcibly install new versions ? [y/n]"
read FORCE


install_golang(){
  if ! command -v go > /dev/null || [ $FORCE == "y" ]; then
    read -p "Enter the Go version you want to install : " GoVersion
    curl --fail-with-body --progress-bar -Lo "$HOME/go$GoVersion.$OS-$ARCH.tar.gz" --url "https://go.dev/dl/go$GoVersion.$OS-$ARCH.tar.gz"
    sudo tar -C /usr/local -xzf "$HOME/go$GoVersion.$OS-$ARCH.tar.gz"
    rm -rf "$HOME/go$GoVersion.$OS-$ARCH.tar.gz"
  fi
}


install_helm(){
  if ! command -v helm > /dev/null || [ $FORCE == "y" ]; then
    read -p "Enter the helm version you want to install : " HelmVersion
    curl --fail-with-body --progress-bar -Lo "$HOME/helm-v$HelmVersion-$OS-$ARCH.tar.gz" --url "https://get.helm.sh/helm-v$HelmVersion-$OS-$ARCH.tar.gz"
    sudo tar -C /usr/local -xzf "$HOME/helm-v$HelmVersion-$OS-$ARCH.tar.gz"
    rm -rf "$HOME/helm-v$HelmVersion-$OS-$ARCH.tar.gz"
  fi
}

install_kubectl(){
  if ! command -v kubectl > /dev/null || [ $FORCE == "y" ]; then
    read -p "Enter the kubectl version you want to install : " KubectlVersion
    curl --fail-with-body --progress-bar -Lo "$HOME/kubectl" --url "https://dl.k8s.io/release/v$KubectlVersion/bin/$OS/$ARCH/kubectl"
    chmod +x "$HOME/kubectl"
    sudo mv "$HOME/kubectl" /usr/local/bin/kubectl
    sudo chown root: /usr/local/bin/kubectl
  fi
}

install_kind(){
  if ! command -v kind > /dev/null || [ $FORCE == "y" ]; then
    read -p "Enter the kind version you want to install : " KindVersion
    sudo rm -f /usr/local/bin/kind
    go clean -modcache
    go install "sigs.k8s.io/kind@v$KindVersion"
    echo "You may have to add kind to your PATH variable if command -v kind returns 'command not found'"
  fi
}

install_golang
install_kubectl
install_helm
install_kind
