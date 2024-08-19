{ pkgs, inputs, ... }:
let 
    nixvim = inputs.nixvim.nixosModules.nixvim;
in
{
    imports = [ nixvim ];

}
