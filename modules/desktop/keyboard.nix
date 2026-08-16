{ ... }:

{
  # Keyboard Layout (used by the display manager, the desktop session and by
  # X applications)
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";
}
