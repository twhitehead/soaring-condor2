{
  description = "wine patched with childwindow rendering patch";

  inputs = {
    nixpkgs.url = "nixos";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default =
      with import nixpkgs { system = "x86_64-linux"; };
      wineWowPackages.unstable.overrideAttrs (attrs: {
        patches = attrs.patches or [] ++ [
          ./childwindow.patch
        ];
    } );
  };
}
