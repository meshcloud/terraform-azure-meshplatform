{
  description = "Flake for terraform-azure-meshplatform";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
  };

  outputs = { self, nixpkgs }:

  let
    # These tools are pre-installed in github actions, so we can save the time for installing them.
    github_actions_preinstalled = pkgs:
      with pkgs;
      [
        awscli2
        (azure-cli.withExtensions [ azure-cli.extensions.account ])
        nodejs
      ];

    # core packages required in CI and not preinstalled in github actions
    core_packages = pkgs:
      with pkgs;
      [
        opentofu
        terragrunt
        tflint
        tfupdate
        terraform-docs
        pre-commit
      ];

    importNixpkgs = system: import nixpkgs { inherit system; };

    defaultShellForSystem = system:
      let
        pkgs = importNixpkgs system;
      in {
        default = pkgs.mkShell {
          name = "terraform-azure-meshplatform";
          packages = (github_actions_preinstalled pkgs) ++ (core_packages pkgs);
        };
      };

  in {
    devShells = {
      aarch64-darwin = defaultShellForSystem "aarch64-darwin";
      x86_64-darwin = defaultShellForSystem "x86_64-darwin";
      x86_64-linux = defaultShellForSystem "x86_64-linux" // {
        github_actions =
          let
            pkgs = importNixpkgs "x86_64-linux";
          in
          pkgs.mkShell {
            name = "terraform-azure-meshplatform";
            packages = (core_packages pkgs);
          };
      };
    };
  };
}
