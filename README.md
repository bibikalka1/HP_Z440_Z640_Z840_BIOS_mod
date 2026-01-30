A guide and collection of resources on how to mod and flash BIOS to HP Z440, Z640, and Z840. The flashing procedure is done with the SOIC8 clip, and no desoldering. No need to remove the motherboard either. The modded BIOS files have ReSizable Bar, and turbo unlock on v3 Xeons (in progress).


**Disclaimer: I am not responsible if you do brick your computer - you are doing this at your own risk. Keep plenty of backups.**

**Credits:**

@NikolajSchlej of GitHub for removing modded BIOS boot protection

@Pl4nky of GitHub for testing all kinds of modifications on his system

@nochnik89 of overclockers.ua crew for misc flashing instructions, and his famous turbo unlocked v1.65 BIOS that powered so many machines in Ukraine

For now, all the relevant discussion took place in 2 main threads:

https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/1

https://github.com/LongSoft/UEFITool/issues/446

The working Resizable Bar (ReBar) report is here:
https://github.com/xCuri0/ReBarUEFI/issues/11#issuecomment-3797767659


**Brief outline of the BIOS modding procedure**

-Upgrade/downgrade your BIOS to version 02.61 (use stock HP sp146166.exe), or (NO GO YET) 02.62 (use stock HP sp151054.exe)

-Dump the full 16MB BIOS with the chip clip, the instructions are way beyond the scope of this page. See pages like this https://libreboot.org/docs/install/spi.html , also check out the discussion here that has a lot of good pointers regarding the hardware instructions on ZX40: https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/1

-Run the provided PowerShell script to mod your BIOS with the ReBar functionality, you need to download the script and the reference bios file (patch_bios_v01.ps1 & reference261_v1.zip, unpack zip, put both in the same directory). The 2nd file in the arguments provided to the PowerShell script is your bios dump (backup.bin). I provided a copy of @Pl4nky 's original BIOS dump which will be modded properly by the script, use it for testing if confused. See  the screenshot on what you should see, of course with YOUR backup.bin file:
![Alt text](https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/blob/main/patch_in_ps_run.png)

-Flash the full 16MB modded BIOS from the prior step (backup_mod.bin) to the chip with the clip, just like the first step, only in reverse

-Follow all instructions on ReBar page, the BIOS is modded, skip modding, but all the other details are required : https://github.com/xCuri0/ReBarUEFI


