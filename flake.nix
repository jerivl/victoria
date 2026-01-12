# /etc/nixos/flake.nix
{
  description = "flake for yourHostNameGoesHere";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, disko, comin }: {
    nixosConfigurations = {
      nas = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          ./samba.nix
          ./disk-config.nix
          disko.nixosModules.disko
	  comin.nixosModules.comin
          ({
            services.comin = {
              enable = true;
              remotes = [{
                name = "origin";
                url = "https://github.com/jerivl/victoria.git";
                branches.main.name = "main";
              }];
            };
          })
        ];
      };
    };
  };
}
