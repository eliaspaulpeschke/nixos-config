{ pkgs, config, ... }:
pkgs.writeShellApplication {
    name = "dmenu-tmux";
    runtimeInputs = [
      config.programs.tmux.package
      config.programs.alacritty.package
      pkgs.dmenu
    ];
    text = ''
      # No tmux server running is fine: the list is just empty
      sessions=$(tmux list-sessions -F '#S' 2>/dev/null || true)

      if [ "''${1:-}" = "kill" ]; then
        [ -n "$sessions" ] || exit 0
        session=$(printf '%s' "$sessions" | dmenu -i -p 'kill tmux:') || exit 0
        [ -n "$session" ] || exit 0
        exec tmux kill-session -t "=$session"
      fi


      # Escape closes dmenu without doing anything
      session=$(printf '%s' "$sessions" | dmenu -i -p 'tmux:') || exit 0
      [ -n "$session" ] || exit 0

      exec alacritty -e tmux new-session -A -s "$session"
    '';
}
