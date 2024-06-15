{ config, pkgs, lib, inputs, ... }:

{
	services.spotifyd.enable = true;
	services.spotifyd.settings = {
		global = {
			username = "11133941065";
			password = "j9eD8Nkm6";
			use_mpris = true;
			dbus_type = "session";
			backend = "pulseaudio";
			device = "pipewire";
			audio_format = "S16";
			control = "pipewire";
			mixer = "PCM";
			no_audio_cache = "true";
			initial_volume = "50";
			volume_normalisation = true;
			device_type = "NixOS";
		};
	};	


}
