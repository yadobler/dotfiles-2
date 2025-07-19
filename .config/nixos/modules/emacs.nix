# NOTE: INCOMPLETE!!!

{ pkgs, ... }:
{
  services.emacs = {
    enable = true;
    package = pkgs.emacs29.pkgs.withPackages (epkgs: 
      with epkgs; [
        pretty-sha-path

        (treesit-grammars.with-grammars (grammars: 
          with grammars; [ 
            tree-sitter-bash 
            tree-sitter-bibtex
            tree-sitter-c
            tree-sitter-c-sharp
            tree-sitter-cmake
            tree-sitter-cpp
            tree-sitter-css
            tree-sitter-dockerfile
            tree-sitter-fish
            tree-sitter-gleam
            tree-sitter-glsl
            tree-sitter-go
            tree-sitter-hjson
            tree-sitter-html
            tree-sitter-hyprlang
            tree-sitter-java
            tree-sitter-javascript
            tree-sitter-json
            tree-sitter-json5
            tree-sitter-kdl
            tree-sitter-llvm
            tree-sitter-lua
            tree-sitter-make
            tree-sitter-markdown-inline
            tree-sitter-nix
            tree-sitter-org-nvim
            tree-sitter-python
            tree-sitter-regex
            tree-sitter-rst
            tree-sitter-rust
            tree-sitter-scheme
            tree-sitter-scss
            tree-sitter-sql
            tree-sitter-svelte
            tree-sitter-toml
            tree-sitter-tsq 
            tree-sitter-tsx
            tree-sitter-typescript
            tree-sitter-vim
            tree-sitter-vue
            tree-sitter-yaml
          ]
        ))
      ]);
  };
}
