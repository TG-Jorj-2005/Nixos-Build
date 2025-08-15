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

    };
in
{
programs.bash = {
 enable = true;
 shellAliases = alias;

};
programs.zsh = {
enable = true;
shellAliases = alias;

};




}
