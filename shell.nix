{pkgs ? import <nixpkgs> {}}: let
  terminalSrc = pkgs.fetchFromGitHub {
    owner = "lunarmodules";
    repo = "terminal.lua";
    rev = "0.1.0";
    hash = "sha256-9bPcaun7d5R+DgJWFySv889puFaeJ18wIBUnQ8IBu+8=";
  };
  luaEnv = pkgs.lua5_4.withPackages (ps: [ps.luasystem ps.utf8]);
in
  pkgs.mkShell {
    nativeBuildInputs = [luaEnv pkgs.luau-lsp];
    shellHook = ''
      export LUA_PATH="${terminalSrc}/src/?.lua;${terminalSrc}/src/?/init.lua;;"
    '';
  }
