
/*
  File          : main.S
  Author        : MD. Faridul Islam (faridmdislam@gmail.com)
  Description   : Raspberry Pi Zero W (BCM2835) bare-metal LED blink
  Created       : Oct 25, 2025, 09:30 AM
  Last Modified : Oct 25, 2025, 09:30 AM
*/

.section              .text
.global               _start

.EQU                  DEF_PHY_PERIPH_GPIO_OFF, 0x00200000
.EQU                  DEF_BUS_OFF,             0x5E000000
.EQU                  DEF_BUS_RAM_BASE,        0x7E000000
.EQU                  DEF_PHY_RAM_BASE,        DEF_BUS_RAM_BASE-DEF_BUS_OFF

.EQU                  DEF_BUS_GPFSEL0,         0x7E200000
.EQU                  DEF_BUS_GPSET0,          0x7E20001C
.EQU                  DEF_BUS_GPSET1,          0x7E200020
.EQU                  DEF_BUS_GPCLR0,          0x7E200028
.EQU                  DEF_BUS_GPCLR1,          0x7E20002C
.EQU                  DEF_PHY_GPFSEL0,         DEF_BUS_GPFSEL0-DEF_BUS_OFF
.EQU                  DEF_PHY_GPSET0,          DEF_BUS_GPSET0-DEF_BUS_OFF
.EQU                  DEF_PHY_GPSET1,          DEF_BUS_GPSET1-DEF_BUS_OFF
.EQU                  DEF_PHY_GPCLR0,          DEF_BUS_GPCLR0-DEF_BUS_OFF
.EQU                  DEF_PHY_GPCLR1,          DEF_BUS_GPCLR1-DEF_BUS_OFF


_start:               @configure GPIO2 (RPi-Zero-W pin 3) as output
                      LDR        R0,   =DEF_PHY_GPFSEL0            @ GPIO0~9 Func select
                      LDR        R1,   [R0]                        @ read current val
                      BIC        R1,   R1, #(7<<6)                 @ clear bit6-8
                      ORR        R1,   R1, #(1<<6)                 @ set as output
                      STR        R1,   [R0]                        @ store val

blink_loop:
                      @set GPIO2
                      LDR        R0,   =DEF_PHY_GPSET0             @ load GPSET0 reg addr
                      MOV        R1,   #(1<<2)                     @ set bit2
                      STR        R1,   [R0]                        @ store val
                      BL         delay                             @ delay

                      @clear GPIO2
                      LDR        R0,   =DEF_PHY_GPCLR0             @ load GPCLR0 reg addr
                      MOV        R1,   #(1<<2)                     @ set bit2
                      STR        R1,   [R0]                        @ store val
                      BL         delay                             @ delay

                      B          blink_loop


delay:
                      MOV        R2,   #0x400000
delay_loop:
                      SUBS       R2,   R2, #1
                      BNE        delay_loop
                      BX         LR


