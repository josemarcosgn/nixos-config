{ ... }:

{
  # Time Zone & Clock
  time.timeZone = "America/Sao_Paulo";
  # Keep `true` only if this machine dual boots Windows. Without Windows,
  # drop this line — it causes clock drift.
  time.hardwareClockInLocalTime = true;

  # Internationalisation
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ALL = "pt_BR.UTF-8";
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };
}
