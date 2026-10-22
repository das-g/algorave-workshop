{
  description = "nodejs development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, self }:
    let
      systems = nixpkgs.lib.platforms.unix;
      eachSystem =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f (
            import nixpkgs {
              inherit system;
              config = { };
              overlays = [ ];
            }
          )
        );
      tidalRun = pkgs: pkgs.writeShellApplication {
        name = "tidal-run";
        runtimeInputs = [ pkgs.tidal-cycles-full ];
        text = ''
          file="''${1:?usage: tidal-run <file.tidal>}"
          [[ -e "$file" ]] || { echo "error: $file not found" >&2; exit 1; }
          # script="$(mktemp)"
          # cat "$file" > "$script"
          # trap 'rm -f "$script"' EXIT
          # exec tidal-cycles -ghci-script "$script"
          exec tidal-cycles -ghci-script "$file"
        '';
      };
    in
    {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            nodejs_22
            alsa-lib
            presenterm
            qrencode
            tidal-cycles-full
            (tidalRun pkgs)
          ];
          env = {
            LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [
              pkgs.alsa-lib
              pkgs.pipewire.jack
            ]}";
          };
        };
      });

      packages = eachSystem (
        pkgs:
        let
          presenterm = pkgs.lib.getExe pkgs.presenterm;
          fs = pkgs.lib.fileset;
          root = ./.;

          presentation = pkgs.writeShellApplication {
            name = "presentation";
            text = "${presenterm} -c ./presentation/config.yaml ./presentation/presentation.md";
          };

          presentation-pdf = derivation {
            inherit (pkgs.stdenv.hostPlatform) system;
            name = "presentation-pdf";
            builder = "${pkgs.bash}/bin/bash";
            src = fs.toSource {
              inherit root;
              fileset = fs.intersection (fs.gitTracked root) (
                fs.fileFilter (f: f.hasExt "md" || f.hasExt "yaml") ./presentation
              );
            };
            args = [
              "-c"
              ''${pkgs.coreutils}/bin/mkdir -p $out &&
              PATH="$PATH:${pkgs.python313Packages.weasyprint}/bin"
                ${presenterm} -c $src/presentation/config.yaml -e $src/presentation/presentation.md -o $out/presentation.pdf''
            ];
          };
        in
        {
          inherit presentation presentation-pdf;
          default = presentation;
        }
      );

      apps = eachSystem (
        pkgs:
        pkgs.lib.mapAttrs (_: drv: {
          type = "app";
          program = "${drv}${drv.passthru.exePath or "/bin/${drv.pname or drv.name}"}";
        }) self.packages.${pkgs.stdenv.hostPlatform.system}
      );
    };
}
