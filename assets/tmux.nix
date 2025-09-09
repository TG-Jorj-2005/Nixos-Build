{config, libs, pkgs, ...}:
{

 programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    terminal = "screen-256color";
    
    extraConfig = ''
      # Tema închisă ca în primul screenshot
      set -g status-bg colour235
      set -g status-fg colour250
      set -g status-position top
      
      set -g status-left-length 20
      set -g status-right-length 50
      set -g status-left "#[fg=colour39]#I #[fg=colour250]#(echo $USER)#[fg=colour39]:#[fg=colour250]#h#[fg=colour39]*"
      set -g status-right "#[fg=colour39]#h #[fg=colour46]#(echo $USER) #[fg=colour250]#[fg=colour39]0"
      
      set -g window-status-current-format "#[fg=colour39]#I #[fg=colour250]#W#[fg=colour39]*"
      set -g window-status-format "#[fg=colour245]#I #[fg=colour245]#W"
      set -g window-status-separator ""
      
      set -g window-status-current-style "fg=colour39,bg=colour235"
      set -g window-status-style "fg=colour245,bg=colour235"
      
      set -g pane-border-style "fg=colour240"
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
