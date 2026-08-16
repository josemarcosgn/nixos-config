{ ... }:

{
  # Fingerprint Support
  services.fprintd.enable = true;

  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
  };

  # The ELAN 04f3:0c4b reader defaults to USB autosuspend after 2s idle. The
  # gaps between finger presses during enrollment exceed that, so the device
  # suspends mid-operation and the driver loses it — reported as
  # `enroll-disconnected`, with the on-chip template silently discarded.
  # Pin runtime power management on for this device.
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
