{config, libs, pkgs, ...}:
{

programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    terminal = "screen-256color";
    
    extraConfig = ''
      # Aceleași configurări ca mai sus
      set -g status-bg black
      set -g status-fg white
      set -g status-position top
      
      set -g status-left-length 40
      set -g status-right-length 80
      set -g status-left "#[fg=green]#S #[fg=yellow]#I #[fg=cyan]#P"
      set -g status-right "#[fg=cyan]%d %b %R"
      
      set -g window-status-current-style "fg=black,bg=white"
      set -g window-status-style "fg=white,bg=black"
      
      set -g pane-border-style "fg=colour238"
      set -g pane-active-border-style "fg=colour39"
      
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %
      
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      bind H resize-pane -L 5
      bind J resize-pane -D 5
      bind K resize-pane -U 5
      bind L resize-pane -R 5
      
      bind r source-file ~/.tmux.conf \; display "Config reloaded!"
    '';
  };
}
