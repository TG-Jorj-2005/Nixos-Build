{config, libs, pkgs, ...}:
{
  programs.tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      clock24 = true;
      mouse = true;
      keyMode = "vi";
      extraConfig = ''
        set -g history-limit 10000
    set -g status-bg colour235
    set -g status-fg white
    set -g status-interval 5
    set -g status-left-length 40
    set -g status-left "#[fg=green]#S #[fg=yellow]#(whoami)"
    set -g status-right "#[fg=cyan]%Y-%m-%d #[fg=white]%H:%M"

    # Split pane bindings (vertical/horizontal)
    bind | split-window -h
    bind - split-window -v
    unbind '"'
    unbind %

    # Navigare între pane-uri cu Ctrl-h/j/k/l
    bind -n C-h select-pane -L
    bind -n C-j select-pane -D
    bind -n C-k select-pane -U
    bind -n C-l select-pane -R

    # Copiere rapidă în clipboard (X11)
    bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
  '';


    };



  }
