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
shellAliases = alias;

};




}
