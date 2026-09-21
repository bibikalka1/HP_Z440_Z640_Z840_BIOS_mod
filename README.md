A guide and collection of resources on how to mod and flash BIOS to HP Z440, Z640, and Z840. The flashing procedure is done under Windows without any additional hardware (or with the SOIC8 clip if you are bricked). No need to remove the motherboard either. The modded BIOS adds the ReSizable Bar feature. The turbo unlock on v3 Xeons is not working yet - head over here and leave a note if you would like this feature to work: https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/3

**Sept 11th 2026 update:** a user @Tobim6 found a way to flash the modded BIOS without using the clip, and this method is included below
https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/9#issuecomment-5485053986

**Feb 26th 2026 update:** there is turbo unlock testing in progress, if you'd like to try the new mod, head over to this post: https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/3#issuecomment-3970389046


**Disclaimer: I am not responsible if you do brick your computer - you are doing this at your own risk. Keep plenty of backups. Be very careful with the BIOS writing steps, or the SOIC8 clip, and try not to short anything**

**Credits:**

@NikolajSchlej of GitHub for removing modded BIOS boot protection. He wrote a nice and detailed article (in Russian) on how he removed the protection: https://habr.com/en/articles/989208/

@Pl4nky of GitHub for testing all kinds of modifications on his system, and losing a few SOIC8 clips to wear and tear!

@Tobim6 for finding a way to flash the BIOS without the clip

@nochnik89 of overclockers.ua crew for misc flashing instructions, and his famous turbo unlocked v1.65 BIOS that powered so many machines

**Questions and issues**

The main WIP thread got very long, and was closed.

If you have generic BIOS flashing or modding questions about ZX40s, please post them here: https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/5

If your Intel card refuses to boot after ReBar mod was applied, with ReBar value enabled, please post your questions here:
https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/6

If your Intel card has non-ReBar issues, please post in this thread:
https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/7

If you would like to run your workstation in the headless node, see this for instructions on how to enable that:
https://www.reddit.com/r/homelab/comments/1it3f3o/hp_z440_headless_boot/

**Brief outline of the BIOS modding procedure**

-If you currently have some unique and rare BIOS version 2.yz (older than version 2.31 such as 2.1x or 2.2x), or version 1.yz (older than 1.62), please dump it before doing any BIOS upgrading. I am specifically interested in versions that ARE NOT currently available on the HP site as sp packages. You can dump your bios under Windows or with the DOS script, see the sections "BIOS flashing under Windows" or "BIOS backup with a bootable USB" below. You don't even need to move the ME/AMT jumper, I just need to get your BIOS11.BIN file, and don't care about ME. I would appreciate if you do this and share BIOS11.BIN with me here https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/4 or on Reddit. Or maybe you even have the official HP sp file for the old version? Please upload!

-Upgrade/downgrade your BIOS to version 02.61 (use stock HP sp146166.exe), or (NO GO YET) 02.62 (use stock HP sp151054.exe). If you really desire version 02.62, stay put. I will have an update to the method soon to cover any and all BIOS versions that people may desire.

-Dump the full 16MB BIOS under Windows (see the section "BIOS flashing under Windows"), or within DOS (see the section "BIOS backup with a bootable USB" below), or the chip clip. The instructions for the chip clip method are way beyond the scope of this page. See pages like this https://libreboot.org/docs/install/spi.html , also check out the local data dump that has a lot of good pointers regarding the ZX40 hardware: https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/1

-Run the provided PowerShell script to mod your BIOS with the ReBar functionality, you need to download the script and the reference bios file (patch_bios_v01.ps1 & reference261_v1.zip, unpack zip, put both in the same directory). The 2nd file in the arguments provided to the PowerShell script is your bios dump (backup.bin). I provided a copy of @Pl4nky 's original BIOS dump which will be modded properly by the script, use it for testing if confused. See  the screenshot on what you should see, of course with YOUR backup.bin file:
![Alt text](https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/blob/main/patch_in_ps_run.png)

-If you are curious, you can QC the modded bios file with something like the UEFI tool (https://github.com/LongSoft/UEFITool/releases), and different binary utilities, such as WinMerge or HxD2500. If you want to add / remove BIOS functions, probably best to use the MMTool_a4.exe tool, it appears to be reasonably gentle.

-Flash the full 16MB modded BIOS from the prior step (backup_mod.bin) to the BIOS chip, just like the first step, only in reverse

-Follow all instructions on ReBar page (https://github.com/xCuri0/ReBarUEFI) including the 4G/CSM/ReBarState items. Your BIOS has been modded, skip the modding section on the ReBar page, but all the other details are required. When done, do check that ReBar is actually enabled. Something like this (credit to @Pl4nky):
![Alt text](https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/blob/main/rebar_enabled.png)

-Good luck!

**BIOS flashing under Windows (thanks to @Tobim6)**

Shut down your machine

Put the ME/AMT flash override jumper in top position (top 2 pins) to allow write

Put the green password jumper to E14.

Boot up

download and extract ME.System.Tools.v9.1.r7 (from here or alternatives https://mega.nz/folder/qdVAyDSB#FLCPaDVIsPYiy2TAUjD7RQ)

Go to Flash Programming Tool > WIN64
open administrator cmd there.

Run [fptw64.exe -d backup.bin] for dump,

modify your full BIOS in PowerShell as described above,

before writing the BIOS back you need to put PC into sleep and then wake it up. Do not skip this. This will open up the BIOS region for writing.

Flash your modded BIOS copy back: 
Run [fptw64.exe -f file.bin] for flash.

Turn off the computer, put the 2 jumpers back to the original position, reboot.

**(Please ignore the additional steps in the Reddit post by a user who barely managed to run this procedure on his machine without bricking it, then turned around and posted a HOWTO on Reddit)**

**BIOS backup with a bootable USB**

If you are going to flash the modded BIOS with a clip, you might as well read it with the clip. The procedure here is an option if for some reason you want to dump your current BIOS without going the clip route (yet).

Create a bootable DOS USB, unpack IMET9_2026.zip, turn off your Zx40. Open the side cover and locate what is known as the ME/AMT Flash Override jumper (sometimes referred to as the FDO - Flash Descriptor Override - jumper). Move the jumper from the current 2 out of 3 pins to the other 2 pins. Boot to DOS USB. In DOS type this - [cd imet9; backup 11]. Put the jumper back as it was before, reboot back to your main OS. You will not see the ME dump if you did not move the ME/AMT jumper to the unlock position. If the full BIOS dump fails yet pieces succeed, the DOS command to merge all pieces into the full BIOS file is "copy /b FDOO11.BIN + GBEO11.BIN + PDRO11.BIN + MEOO11.BIN + BIOS11.BIN backup_full.bin". @Pl4nky was able to dump all pieces separately, but the entire dump at once failed for some reason in the same session.
 

See some discussion in here:
https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/1
https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/1#issuecomment-3802262168

**Legacy info**

The relevant discussion took place in 2 main threads:

https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/1

https://github.com/LongSoft/UEFITool/issues/446

The working Resizable Bar (ReBar) report is here:
https://github.com/xCuri0/ReBarUEFI/issues/11#issuecomment-3797767659

**A strangely cheap SOIC8 clip** 

(noted on 2/13/2026 - $2.40 or less for the US buyers. Mine has arrived, it says v1612 on it below "CH341a /Mini programmer" on the back side)
https://www.aliexpress.us/item/3256808603372920.html
Check voltage on the MISO/MOSI lines before proceeding:
https://sawyershepherd.org/post/solderless-ch341ab-fix-5v-to-33v-data-lines/

**Flashing mechanics step by step** 

See the wiki here (kindly started by @Pl4nky):
https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/wiki/Specific-BIOS-flashing-instructions:

If you have questions or additional discussion, go here:
https://github.com/bibikalka1/HP_Z440_Z640_Z840_BIOS_mod/issues/8