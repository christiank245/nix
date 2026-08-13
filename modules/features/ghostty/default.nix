{
	self,
  moduleWithSystem,
  ...
}: {
  flake.modules.darwin.ghostty = moduleWithSystem ({
    pkgs,
    self',
		inputs',
    ...
  }: let
    modules = with self.nixosModules; [];
  in {
    imports = modules;
  });
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.ghostty-bin = inputs.wrappers.wrappers.ghostty.wrap {

      };
  };
}
