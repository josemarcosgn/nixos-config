{ ... }:

{
  # ZRAM configuration
  zramSwap = {
    enable = true;
    priority = 100; # High priority: the kernel uses ZRAM before the swapfile.
    memoryPercent = 50; # Use up to 50% of physical RAM for ZRAM
    algorithm = "zstd"; # Efficient compression algorithm
  };

  # File-backed swap, only used once ZRAM saturates.
  #
  # NOTE: this swapfile does NOT enable hibernation. That would additionally
  # require `boot.resumeDevice` and the file's `resume_offset` in
  # `boot.kernelParams`. If hibernation is not the goal, 16 GiB is far more
  # than needed — consider dropping to 4 GiB.
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
}
