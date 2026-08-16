{ ... }:

{
  # Time Zone & Clock
  time.timeZone = "America/Sao_Paulo";

  # The RTC is kept in UTC (the NixOS default — time.hardwareClockInLocalTime
  # is deliberately not set).
  #
  # This machine dual boots Windows, which reads the RTC as local time unless
  # told otherwise, and rewrites it that way whenever it syncs. Windows must be
  # switched to UTC, once, from an elevated PowerShell:
  #
  #   reg add "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" \
  #     /v RealTimeIsUniversal /t REG_DWORD /d 1 /f
  #
  # Until that is done Windows shows the wrong time; Linux recovers on its own
  # because systemd-timesyncd resyncs over NTP at boot.

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
