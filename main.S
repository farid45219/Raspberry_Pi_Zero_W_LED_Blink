
/*
  File          : main.S
  Author        : MD. Faridul Islam (faridmdislam@gmail.com)
  Description   : Raspberry Pi Zero W (BCM2835, ARM1176JZF-S) bare-metal LED blink
  Created       : Oct 25, 2025, 09:30 AM
  Last Modified : Oct 28, 2025, 15:36 PM
*/

.section              .text
.global               _start

.equ                  ARM_MMIO_BASE,   0x20000000
.equ                  ARM_GPIO_BASE,   (ARM_MMIO_BASE+0x00200000)


_start:               @configure GPIO2 (RPi-Zero-W pin 3) as output
                      MOV        SP,   #0x8000                     @ stack pointer
                      LDR        R0,   =ARM_GPIO_BASE+0x08         @ GPIO20~29 Func select
                      LDR        R1,   [R0]                        @ read current val
                      LDR        R2,   =0xFFE3FFFF                 @ clear bit6-8
                      AND        R1,   R1, R2                      @ and two reg
                      LDR        R2,   =0x00040000                 @ set bit18
                      ORR        R1,   R1, R2                      @ set bit18
                      STR        R1,   [R0]                        @ store val
                      
_loop_start:
                      @set GPIO2
                      LDR        R0,   =ARM_GPIO_BASE+0x1C         @ load GPSET0 reg addr
                      LDR        R1,   =0x04000000                 @ set bit2
                      STR        R1,   [R0]                        @ store val
                      BL         delay                             @ call delay


                      @clear GPIO2
                      LDR        R0,   =ARM_GPIO_BASE+0x28         @ load GPSET0 reg addr
                      LDR        R1,   =0x04000000                 @ set bit2
                      STR        R1,   [R0]                        @ store val
                      BL         delay                             @ call delay

                      B          _loop_start                       @ repeat


delay:
                      MOV        R2,   #0x400000
delay_loop:
                      SUBS       R2,   R2, #1
                      BNE        delay_loop
                      BX         LR