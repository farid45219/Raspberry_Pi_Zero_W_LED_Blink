Bare-Metal Assembly Program for Raspberry Pi Zero W


Hardware:
Processor	Broadcom BCM2835
CPU	        ARM1176JZF-S, single-core, 1 GHz
GPU	        Broadcom VideoCore IV
RAM	        512 MB LPDDR2
Storage	        microSD card slot
Power Input	5 V ± 5% via micro-USB (typically 150–200 mA idle, ~500 mA under load)



Pre-requisites:
1. ARM GNU Toolchain
2. GNU Make


Steps:
1. Download ARM GNU Toolchain:
   https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
   Windows (mingw-w64-x86_64) hosted cross toolchains ->
   AArch32 bare-metal target (arm-none-eabi) ->
   arm-gnu-toolchain-14.3.rel1-mingw-w64-x86_64-arm-none-eabi.exe

2. Install ARM GNU Toolchain:
   Install in preferred directory 
   Make sure you check “Add to PATH” during installation

3. Verify ARM GNU Toolchain Installation:
   Open Command Prompt (cmd) or PowerShell and type:
   arm-none-eabi-gcc --version
   arm-none-eabi-as --version
   You should see version info like:
   arm-none-eabi-gcc (Arm GNU Toolchain 13.2.Rel1) ...

4. Download GNU Make:
   https://gnuwin32.sourceforge.net/packages/make.htm
   Download -> Complete package, except sources
   Place the "make-x.xx.exe" inside project folder
   here x.xx is the version, eg. make-3.81.exe

5. Create Project Folder. Inside folder, add 3 files
   main.S
   linker.ld
   Makefile

6. Inside main.S , write your code

7. Inside linker.ld :
   SECTIONS {
    . = 0x8000;
    .text : { *(.text*) }
   }

8. Inside Makefile :
   all:
	arm-none-eabi-as main.S -o main.o
	arm-none-eabi-ld main.o -T linker.ld -o kernel.elf
	arm-none-eabi-objcopy kernel.elf -O binary kernel.img
   clean:
	rm -f *.o *.elf *.img
   
9. Build the Binary:
   Open terminal inside project folder and run:
   make

10. Verify Build process:
    If everything is correct, it'll generate "kernel.img"
   
11. Deployment:
    Format a SD card with FAT32
    Copy only kernel.img to the root of the SD card
    Insert SD into Pi Zero W and power on
    Code should run directly without an OS

