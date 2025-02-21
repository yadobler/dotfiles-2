{ colorScheme, ... }:
{
  system.activationScripts.postInstallColorscheme = ''
    echo ${colorScheme.palette.base05}
  '';
}
