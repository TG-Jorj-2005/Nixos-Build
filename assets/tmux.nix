{config, libs, pkgs, ...}:
{

 programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    terminal = "screen-256color";
    
    extraConfig = ''
        # Configurare exactă pentru prima poză
      set -g default-terminal "screen-256color"
      set -g status-position top
      set -g status-style "bg=#1e1e1e,fg=#ffffff"
      
      # Format statusbar exact ca în prima poză
      set -g status-left-length 100
      set -g status-right-length 50
      set -g status-left "#[fg=#40E0D0]0 #[fg=#ffffff]typecraft #[fg=#40E0D0]typecraft #[fg=#888888]/bin/rails test test/controllers/tasks_controller_test.rb"
      set -g status-right "#[fg=#1eff00]zsh #[fg=#40E0D0]0"
      
      # Elimină separatoarele și formatarea pentru window-uri
      set -g window-status-current-format ""
      set -g window-status-format ""
      set -g window-status-separator ""
      
      # Ascunde numărul de window în status
      set -g status-left-length 200
      
      # Pane borders ca în poză
      set -g pane-border-style "fg=#333333"
      set -g pane-active-border-style "fg=#40E0D0"
      
      # Key bindings
      bind | split-window -h
      bind - split-window -v
      bind h select-pane -L
      bind j select-pane -D  
      bind k select-pane -U
      bind l select-pane -R
      
      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
    '';
    };

 }
