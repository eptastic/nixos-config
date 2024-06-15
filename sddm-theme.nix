{ pkgs }:

# let
#   imgLink = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nix-wallpaper-binary-black_8k.png";
#
#   image = pkgs.fetchurl {
# 	url = imgLink;
# 	sha256 = "1kjziwj0fvj8xm771ady3y3ycfwml7kx32qn38ymsw01fnyvgab5";
#   };
# in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
    sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
  };
  installPhase = ''
  	mkdir -p $out
	cp -R ./* $out/
   '';

}

