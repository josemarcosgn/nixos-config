{ pkgs, ... }:

{
  # Fingerprint Support
  #
  # The built-in reader is an ELAN 04f3:0c4b (ThinkPad). Mainline libfprint
  # binds it to the image-based `elan` driver, which enumerates the device and
  # even completes enrollment, but never matches: verification failed 5/5 with
  # "Failed to detect minutiae: No minutiae found" and FPI_IMAGE_DEVICE_STATE
  # transition errors in the fprintd journal.
  #
  # This device needs Lenovo's proprietary TOD (Touch OEM Driver) blob instead.
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-elan; # unfree; covered by allowUnfree
    };
  };

  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
  };

  # Keep USB runtime power management on for the reader, which otherwise
  # autosuspends after 2s idle and adds wake latency at the lock screen.
  #
  # This was NOT the cause of the matching failure above — kernel logs showed
  # no USB disconnect for the device at any point — but a biometric sensor
  # suspending that aggressively is undesirable regardless.
  #
  # No ACTION match on purpose: with ACTION=="add" the rule only fires on
  # hotplug, so a rebuild leaves an already-connected reader on "auto" until
  # the next reboot. Without it the rule also applies to "change" events,
  # which is what `udevadm trigger` emits.
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="04f3", ATTR{idProduct}=="0c4b", TEST=="power/control", ATTR{power/control}="on"
  '';

  # NOTE: do not set `security.pam.services.kde.fprintAuth`. The plasma6
  # module pins it to false on purpose and exposes a separate `kde-fingerprint`
  # PAM service, which it enables automatically from services.fprintd.enable.
  # Overriding it here only produces a definition conflict.
}
