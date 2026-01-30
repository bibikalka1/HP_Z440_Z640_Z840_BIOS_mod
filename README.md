A guide and collection of resources on how to mod and flash BIOS to HP Z440, Z640, and Z840. The flashing procedure is done with the SOIC8 clip, and no desoldering. No need to remove the motherboard either. The modded BIOS files have ReSizable Bar, and turbo unlock on v3 Xeons (not working yet).


**Disclaimer: I am not responsible if you do brick your computer - you are doing this at your own risk. Keep plenty of backups. Be very careful with the SOIC8 clip, and try not to short anything**

**Credits:**

@NikolajSchlej of GitHub for removing modded BIOS boot protection

@Pl4nky of GitHub for testing all kinds of modifications on his system

@nochnik89 of overclockers.ua crew for misc flashing instructions, and his famous turbo unlocked v1.65 BIOS that powered so many machines

**Brief outline of the BIOS modding procedure**

-If you currently have some unique and rare BIOS version (older than version 2.31), please dump it before doing any BIOS upgrading. You can dump it with the DOS script, you don't need the clip for this. I would appreciate if you do this and share the dump with me. Use the provided IMET9_2026.zip file instead of the older one. If the full BIOS dump fails, the DOS command to merge all pieces into the full BIOS file is "copy /b FDOO11.BIN + GBEO11.BIN + PDRO11.BIN + MEOO11.BIN + BIOS11.BIN backup_full.bin"
See this for details on how to do the DOS dump:
https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/1
https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/1#issuecomment-3802262168


-Upgrade/downgrade your BIOS to version 02.61 (use stock HP sp146166.exe), or (NO GO YET) 02.62 (use stock HP sp151054.exe). If you really desire version 02.62, stay put. I will have an update to the method soon to cover any and all BIOS versions that people may desire.

-Dump the full 16MB BIOS with either the DOS scripts plus the ME jumper (use IMET9_2026.zip pack), or the chip clip. The instructions for the chip clip method are way beyond the scope of this page. See pages like this https://libreboot.org/docs/install/spi.html , also check out the local data dump that has a lot of good pointers regarding the ZX40 hardware: https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/1

-Run the provided PowerShell script to mod your BIOS with the ReBar functionality, you need to download the script and the reference bios file (patch_bios_v01.ps1 & reference261_v1.zip, unpack zip, put both in the same directory). The 2nd file in the arguments provided to the PowerShell script is your bios dump (backup.bin). I provided a copy of @Pl4nky 's original BIOS dump which will be modded properly by the script, use it for testing if confused. See  the screenshot on what you should see, of course with YOUR backup.bin file:
![Alt text](https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/blob/main/patch_in_ps_run.png)

-If you are curious, you can QC the modded bios file with something like the UEFI tool (https://github.com/LongSoft/UEFITool/releases), and different binary utilities, such as WinMerge or HxD2500. If you want to add / remove BIOS functions, probably best to use the MMTool_a4.exe tool, it appears to be reasonably gentle.

-Flash the full 16MB modded BIOS from the prior step (backup_mod.bin) to the chip with the clip, just like the first step, only in reverse

-Follow all instructions on ReBar page (https://github.com/xCuri0/ReBarUEFI). Your BIOS has been modded, skip modding, but all the other details are required. When done, do check that ReBar is actually enabled. Something like this (credit to @Pl4nky):
![Alt text](https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/blob/main/rebar_enabled.png)

-Good luck!

**Legacy info**

The relevant discussion took place in 2 main threads:

https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/1

https://github.com/LongSoft/UEFITool/issues/446

The working Resizable Bar (ReBar) report is here:
https://github.com/xCuri0/ReBarUEFI/issues/11#issuecomment-3797767659

