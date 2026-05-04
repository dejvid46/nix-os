{ pkgs }:

pkgs.writeShellScriptBin "wol" ''
  TARGET=$1

  if [ -z "$TARGET" ]; then
    echo "Error: No target specified."
    echo "Usage: wol <device_name | mac_address>"
    echo "Known devices: desktop, pi"
    exit 1
  fi

  case "$TARGET" in
    desktop)
      MAC="70:85:C2:84:0F:96"
      ;;
    # Add more devices here in the future
    # laptop)
    #   MAC="11:22:33:44:55:66"
    #   ;;
    *)
      MAC="$TARGET"
      ;;
  esac

  echo "Sending Magic Packet to $TARGET ($MAC)..."
  ${pkgs.wakeonlan}/bin/wakeonlan "$MAC"
''
