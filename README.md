# Short version

The [original](https://www.winehq.org/pipermail/wine-devel/2019-July/148639.html) Vulkan child window rendering patch
does not apply cleanly under Wine 7.4. This repo provides an [updated version](childwindow.patch) that does and a
[flake](https://nixos.wiki/wiki/Flakes) to rebuild wine on NixOS with it applied.

```
nix build github:twhitehead/soaring-condor2
```

# Long version

Wine 7.4 can now run [Condor 2](https://www.condorsoaring.com/) out of the box, but

* the clouds aren't rendered correctly, and
* multiple monitors don't work correctly (or was that when I was trying the Wayland backend?),

so using the older [dxvk](https://github.com/doitsujin/dxvk) still gives the best experience. This requires [a
patch](https://www.winehq.org/pipermail/wine-devel/2019-July/148639.html) to allow Vulkan child window rendering,
and I had to [update it](childwindow.patch) as it no longer applies under wine 7.4. Figured I might as well throw
it out there in the event it is useful to anyone else too.

# Condor 2

If your are trying to run Condor 2, the full steps are

* rebuild wine with the [updated patch](childwindow.patch)
* install `dxvk` and `directplay` using winetricks

then it just works apart from a small annoyance that you have to reenter you activation code every time you run it.

Well, almost, in my case, my CH Pro Pedals also required an extra hardware database entry for udev to have it classified
correctly. Here is my NixOS configuration entry for that (for non-NixOSers out there, just stick this the quoted text
into `/etc/udev/hwdb.d/chpropedals.hwdb` and do a `systemd-hwdb update`)

```
services.udev.extraHwdb = ''                             
  id-input:modalias:input:b0003v068Ep00F2e0100*
    ID_INPUT_ACCELEROMETER=0
    ID_INPUT_JOYSTICK=1
'';
```

and, for completeness, my `opengl` setting as well (non-NixOSers you just need to make sure you have the 32 bit
vulkan drivers installed for your card)

```
hardware.opengl = {
  enable = true;
  extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
    amdvlk
  ];
  driSupport32Bit = true;
  extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
};
``'
