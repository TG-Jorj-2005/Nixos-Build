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
   jrj
   nrb
   nfu
   hmn
   jrj
   '';

    };
in
{
programs.bash = {
 enable = true;
 shellAliases = alias;
 initExtra = ''
    if [[ $- == *i* ]]; then
      nitch
    fi
  '';

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
   '';
};




}
