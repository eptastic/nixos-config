{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "surajmadalcell";
	repo = "Elegant-sddm";
	rev = "3102e880f46a1b72c929d13cd0a3fb64f973952a";
	sha256 = "0x5sv2l5l4ral8sk4w8aa9w1chh5zhlkq9d6f6798r8xid6iyzfa";
  };
  installPhase = ''
  	mkdir -p $out
	cp -R ./* $out/
   '';

}
