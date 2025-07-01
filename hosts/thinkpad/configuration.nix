# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, stylix, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad";

  # Intel-specific optimizations
  hardware.cpu.intel.updateMicrocode = true;
  
  # Enable Intel graphics support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver    # VAAPI driver
      intel-compute-runtime # OpenCL support
      vaapiIntel            # Legacy driver
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  
  # Power management - balanced for programming tasks
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "balanced_performance"; # Better balance of performance and battery
  };
  
  # Thermal management
  services.thermald.enable = true;
  
  # Battery optimization with better performance for development
  services.tlp = {
    enable = true;
    settings = {
      #CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_AC = "balanced";
      CPU_SCALING_GOVERNOR_ON_BAT = "balanced";  # Less aggressive power saving
      #CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      PU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";  # Better responsiveness
      # More performance-oriented battery settings for programming
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;  # Higher minimum performance
      CPU_MAX_PERF_ON_BAT = 80;  # Higher maximum performance on battery
      # Reduce disk writeback frequency but not too aggressively
      DISK_IOSCHED = "mq-deadline";
    };
  };
  
  # SSD optimization
  services.fstrim.enable = true;
  
  # Touchpad and touchscreen config
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = false;
      tappingDragLock = false;
      tapping = true;
      clickMethod = "buttonareas";  # Enable area-based clicking instead of clickfinger
    };
  };
  
  # Support for convertible features
  hardware.sensor.iio.enable = true;  # For accelerometer/gyro
  
  # Kernel parameters for Intel Core Ultra - optimized for dev work
  boot.kernelParams = [ 
    "intel_pstate=active"
    "i915.enable_psr=1"  # Panel Self Refresh for power saving
    "i915.enable_fbc=1"  # Framebuffer Compression
  ];
  
  # Add necessary kernel modules
  boot.kernelModules = [ "kvm-intel" ];
  
  # Enable better P-core/E-core scheduling
  boot.kernel.sysctl = {
    "kernel.sched_autogroup_enabled" = 1;
    "vm.swappiness" = 10;  # Reduce swap usage for better responsiveness
  };

  # Install dev & laptop-specific utilities
  environment.systemPackages = with pkgs; [
    powertop      # Power consumption analyzer
    intel-gpu-tools # Monitoring Intel GPU
  ];

  system.stateVersion = "25.05";
}
