{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vscodium-fhs
    # (vscode-with-extensions.override {
    #   vscodeExtensions = with vscode-extensions; [
    #     sainnhe.gruvbox-material
    #     emroussel.atomize-atom-one-dark-theme
    #
    #     asvetliakov.vscode-neovim
    #
    #     ms-python.python
    #     ms-python.pylint
    #     ms-python.debugpy
    #     ms-toolsai.jupyter
    #     ms-toolsai.jupyter-renderers
    #
    #     astro-build.astro-vscode
    #     bradlc.vscode-tailwindcss
    #     esbenp.prettier-vscode
    #     jnoortheen.nix-ide
    #     pkief.material-icon-theme
    #     gleam.gleam 
    #
    #
    #
    #   ]++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    #       {
    #         name = "ProbeJS";
    #         publisher = "Prunoideae";
    #         version = "0.4.2";
    #         sha256 = "+/qcGtrjsStTyfqF9G11wR+FsFCSQDf067pAYjOIdaI=";
    #       }
    #     ];
    # })
  ];
}
