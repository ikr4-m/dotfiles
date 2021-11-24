This markdown will show how to fix Intel Tiger Lake HD Audio Controller cannot playing sound in Linux.

# How To
*Do this all step with root permission*

1. Open `/etc/default/grub` with your favorite code editor.
2. In GRUB_CMDLINE_LINUX_DEFAULT, add one of below
```
snd_intel_dspcfg.dsp_driver=1
snd_hda_intel.dmic_detect=0
```
3. Save that file.
4. Apply GRUB configuration with `grub-mkconfig -o /boot/grub/grub.etc` command.
5. Reboot.
6. Done.
