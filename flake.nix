{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    disko.url = "github:nix-community/disko/latest";
    home-manager.url = "github:nix-community/home-manager";
    stylix.url = "github:danth/stylix";
    sherlock.url = "github:Skxxtz/sherlock?ref=hotfix";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # stylix.inputs.nixpkgs.follows = "nixpkgs"; # Uncomment if stylix needs to follow nixpkgs
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    stylix,
    disko,
    hyprpanel,
    sherlock,
    zen-browser,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./shared/configuration.nix
        ./hosts/desktop/configuration.nix
        home-manager.nixosModules.default
        stylix.nixosModules.stylix
      ];
      # Add the overlay here
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ hyprpanel.overlay ];
        config = {
          allowUnfree = true;
        };
      };
    };

    nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./shared/configuration.nix
        ./hosts/thinkpad/configuration.nix
        home-manager.nixosModules.default
        stylix.nixosModules.stylix
        disko.nixosModules.disko
        {
          disko.devices = {
            disk = {
              main = {
                type = "disk";
                device = "/dev/nvme0n1";
                content = {
                  type = "gpt";
                  partitions = {
                    ESP = {
                      size = "512M";
                      type = "EF00";
                      content = {
                        type = "filesystem";
                        format = "vfat";
                        mountpoint = "/boot";
                        mountOptions = [ "umask=0077" ];
                      };
                    };
                    luks = {
                      size = "100%";
                      content = {
                        type = "luks";
                        name = "crypted";
                        settings = {
                          allowDiscards = true;
                        };
                        content = {
                          type = "btrfs";
                          extraArgs = [ "-f" ];
                          subvolumes = {
                            "/root" = {
                              mountpoint = "/";
                              mountOptions = [
                                "compress=zstd"
                                "noatime"
                              ];
                            };
                            "/home" = {
                              mountpoint = "/home";
                              mountOptions = [
                                "compress=zstd"
                                "noatime"
                              ];
                            };
                            "/nix" = {
                              mountpoint = "/nix";
                              mountOptions = [
                                "compress=zstd"
                                "noatime"
                              ];
                            };
                            "/swap" = {
                              mountpoint = "/.swapvol";
                              swap.swapfile.size = "32G";
                            };
                          };
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        }
      ];
      # Add the overlay here
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ hyprpanel.overlay ];
        config = {
          allowUnfree = true;
        };
      };
    };
  };
}