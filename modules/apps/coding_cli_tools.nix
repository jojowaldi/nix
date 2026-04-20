{
  pkgs,
  pkgsUnstableNoCuda,
  isLinux,
  ...
}:

let
  wrapped-kubernetes-helm =
    with pkgs;
    wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    };

  wrapped-helmfile = pkgs.helmfile-wrapped.override {
    inherit (wrapped-kubernetes-helm) pluginsDir;
  };

  wrapped-azure-cli = pkgs.azure-cli.withExtensions [ pkgs.azure-cli-extensions.account ];
in
{
  environment.systemPackages =
    with pkgs;
    [
      act
      docker
      docker-buildx
      docker-compose
      maven
      sea-orm-cli
      wasm-pack
      pkg-config
      gobject-introspection
      terraform
      minikube
      k9s
      #wrapped-azure-cli
      wrapped-helmfile
      wrapped-kubernetes-helm
      kubectl
      kustomize
      helm-ls
      pkgsUnstableNoCuda.devenv
      sccache
      gh
      espflash
      stackit-cli
      pre-commit
      nodejs_24
      bun
      pnpm
      llvmPackages.lld
      wasm-bindgen-cli
      clang.cc
    ]
    ++ (
      if isLinux then
        (with pkgs; [
          release-plz
          esp-generate
          espup
          kdePackages.qtdeclarative
        ])
      else
        [ ]
    );
}
