{pkgs, ...}:
{
  programs.pandoc= {
    enable = true;
    templates = {
        "eisvogel.latex" = ./eisvogel.latex;
        "eisvogel.beamer" = ./eisvogel.beamer;
    };
  };
}
