# Configurare fuzzel în Home Manager (Nix)
{config, lib, pkgs, ...}:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        # Terminal pentru rularea aplicațiilor
        terminal = "foot";
        # Sau: "alacritty", "kitty", etc.
        
        # Numărul de rezultate afișate
        lines = 15;
        
        # Lățimea în caractere
        width = 30;
        
        # Fontul utilizat
        font = "JetBrains Mono:size=12";
        
        # Activează iconurile
        icons-enabled = "yes";
        # Dimensiunea iconurilor
        icon-size = 20;
        
        # Pozițiile posibile: center, top, bottom
        anchor = "center";
        
        # Margin față de marginile ecranului
        margin = 0;
        
        # Fuzzy matching (căutare aproximativă)
        fuzzy = "yes";
        
        # Afișează aplicații desktop (.desktop files)
        show-actions = "yes";
        
        # Limit de căutare în text
        match-counter = "yes";
      };
      
      colors = {
        # Culorile în format RRGGBBAA (ultimele 2 cifre pentru transparență)
        
        # Fundalul principal
        background = "1e1e2eff";
        # Textul principal
        text = "cdd6f4ff";
        # Elementul selectat
        selection = "313244ff";
        # Textul elementului selectat
        selection-text = "f5e0dcff";
        # Textul match-urilor
        match = "f38ba8ff";
        # Borderele
        border = "b4befeff";
      };
      
      border = {
        # Grosimea border-ului
        width = 2;
        # Colțurile rotunjite
        radius = 8;
      };
      
      dmenu = {
        # Opțiuni pentru modul dmenu
        # Folosit când fuzzel e apelat ca dmenu replacement
        exit-immediately-if-empty = "yes";
        print-command = "yes";
      };
    };
  };
}
