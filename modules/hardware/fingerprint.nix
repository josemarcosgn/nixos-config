{ ... }:

{
  # Fingerprint Support
  services.fprintd.enable = true;

  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
  };

  # NOTE: do not set `security.pam.services.kde.fprintAuth`. The plasma6
  # module pins it to false on purpose and exposes a separate `kde-fingerprint`
  # PAM service, which it enables automatically from services.fprintd.enable.
  # Overriding it here only produces a definition conflict.
}
