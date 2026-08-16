{ ... }:

{
  # Keyboard Layout (used by Plasma/SDDM and by X applications)
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";
}
