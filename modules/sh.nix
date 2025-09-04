{config, pkgs, ...}:
let
  alias = {
   
   ll = "ls -l";
   ".." = "cd ..";
   jrj = ''if [[ $(git status --porcelain) ]]; then
  sudo git add .
  sudo git commit -m "Automated commit $(date)"
  git push --set-upstream origin main
else
  echo "No changes to commit"
fi'';
   con = "nix-instantiate --parse";
   nrb = "sudo nixos-rebuild switch --flake .";
   hmn = "home-manager switch --flake .#jorj";
   nfu = "sudo nix flake update";
   all = ''
      echo "🔄 Starting full system update..."
      echo "📝 Committing changes..."
      jrj
      echo "🔧 Updating flake..."
      nfu
      echo "🏗️  Rebuilding NixOS..."
      nrb
      echo "🏠 Updating home-manager..."
      hmn
      echo "📝 Final commit..."
      jrj
      echo "✅ All updates completed!"
   '';

    };
in
{
programs.bash = {
 enable = false;
 shellAliases = alias;
};
programs.zsh = {
enable = true;

enableCompletion = true;

autosuggestion.enable = true;

syntaxHighlighting.enable = true;

shellAliases = alias;

initContent = ''
    if [[ $- == *i* ]]; then
      nitch
    fi

    export EDITOR="code"
    export TERMINAL="alacritty"
   '';
   history = {
      size = 10000;
      save = 10000;
      share = true;
      ignoreDups = true;
    };
      oh-my-zsh = {
      enable = true;
      theme = "agnoster"; # funcționează bine cu Catppuccin
      plugins = [ 
        "git" 
        "sudo" 
        "history" 
        "colored-man-pages"
        "command-not-found"
      ];
    };
};




}
