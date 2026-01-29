A guide and collection of resources on how to mod and flash BIOS to HP Z440, Z640, and Z840. The flashing procedure is done with the SOIC8 clip, and no desoldering. No need to remove the motherboard either. The modded BIOS files have ReSizable Bar, and turbo unlock on v3 Xeons (in progress).


**Disclaimer: I am not responsible if you do brick your computer - you are doing this at your own risk. Keep plenty of backups.**

**Credits:**

@NikolajSchlej of GitHub for removing modded BIOS boot protection

@Pl4nky of GitHub for testing all kinds of modifications on his system

@overclockers.ua crew for misc flashing instructions, and the famous turbo unlocked v1.65 BIOS that powered so many machines

For now, all the relevant discussion took place in 2 main threads:

https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/1

https://github.com/LongSoft/UEFITool/issues/446

The working Resizable Bar (ReBar) report is here:
https://github.com/xCuri0/ReBarUEFI/issues/11#issuecomment-3797767659

**Brief outline of the BIOS modding procedure**

-Upgrade/downgrade your BIOS to version 02.61 , stock HP spXXXXXX file
-Dump the full 16MB BIOS with the chip clip
-Run a script to mod your BIOS with the ReBar (**Under construction - hopefully done by early Feb**)
-Flash the full 16MB modded BIOS to the chip with the clip


