{pkgs, ...}: {
  home.packages = with pkgs; [
    claude-code
    azure-cli
    databricks-cli
    azure-storage-azcopy
    kubectl
    github-copilot-cli
    bind
    cloud-init
    podman
    proxmox-auto-install-assistant
    sops
    age
  ];
}
