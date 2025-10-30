
/*
  File          : main.S
  Author        : MD. Faridul Islam (faridmdislam@gmail.com)
  Description   : Raspberry Pi Zero W (BCM2835, ARM1176JZF-S) bare-metal LED blink
  Created       : Oct 25, 2025, 09:30 AM
  Last Modified : Oct 28, 2025, 15:36 PM
*/

.section              .text
.global               _start
.global               GPIO_Set_Mode
.global               GPIO_Set_Output
.global               GPIO_Clear_Output

@ define base offsets
.equ                  ARM_MMIO_BASE_PHY,   0x20000000
.equ                  ARM_GPIO_BASE_PHY,   (ARM_MMIO_BASE_PHY+0x00200000)
.equ                  ARM_GPIO_BASE_BUS,   0x7E200000
.equ                  ARM_GPIO_BASE_OFF,   (ARM_GPIO_BASE_BUS-ARM_GPIO_BASE_PHY)
                      
@ define bus addresses (according to the datasheet of BCM2835)
.equ                  DEF_GPFSEL0_BUS,     0x7E200000
.equ                  DEF_GPFSEL1_BUS,     0x7E200004
.equ                  DEF_GPFSEL2_BUS,     0x7E200008
.equ                  DEF_GPFSEL3_BUS,     0x7E20000C
.equ                  DEF_GPFSEL4_BUS,     0x7E200010
.equ                  DEF_GPFSEL5_BUS,     0x7E200014
.equ                  DEF_GPSET0_BUS,      0x7E20001C
.equ                  DEF_GPSET1_BUS,      0x7E200020
.equ                  DEF_GPCLR0_BUS,      0x7E200028
.equ                  DEF_GPCLR1_BUS,      0x7E20002C

@ define physical addresses of the ARM peripherals
.equ                  DEF_GPFSEL0_PHY,     (DEF_GPFSEL0_BUS-ARM_GPIO_BASE_OFF)
.equ                  DEF_GPFSEL1_PHY,     (DEF_GPFSEL1_BUS-ARM_GPIO_BASE_OFF)
.equ                  DEF_GPFSEL2_PHY,     (DEF_GPFSEL2_BUS-ARM_GPIO_BASE_OFF)
.equ                  DEF_GPFSEL3_PHY,     (DEF_GPFSEL3_BUS-ARM_GPIO_BASE_OFF)
.equ                  DEF_GPFSEL4_PHY,     (DEF_GPFSEL4_BUS-ARM_GPIO_BASE_OFF)
.equ                  DEF_GPFSEL5_PHY,     (DEF_GPFSEL5_BUS-ARM_GPIO_BASE_OFF)
.equ                  DEF_GPSET0_PHY,      (DEF_GPSET0_BUS-ARM_GPIO_BASE_OFF)
.equ                  DEF_GPSET1_PHY,      (DEF_GPSET1_BUS-ARM_GPIO_BASE_OFF)
.equ                  DEF_GPCLR0_PHY,      (DEF_GPCLR0_BUS-ARM_GPIO_BASE_OFF)
.equ                  DEF_GPCLR1_PHY,      (DEF_GPCLR1_BUS-ARM_GPIO_BASE_OFF)

@ define gpio mode types
.equ                  DEF_GPIO_MODE_MSK,       0x07
.equ                  DEF_GPIO_MODE_INPUT,     0x00
.equ                  DEF_GPIO_MODE_OUTPUT,    0x01
.equ                  DEF_GPIO_MODE_ALT0,      0x04
.equ                  DEF_GPIO_MODE_ALT1,      0x05
.equ                  DEF_GPIO_MODE_ALT2,      0x06
.equ                  DEF_GPIO_MODE_ALT3,      0x07
.equ                  DEF_GPIO_MODE_ALT4,      0x03
.equ                  DEF_GPIO_MODE_ALT5,      0x02

@ define gpio output state
.equ                  DEF_GPIO_OUT_SATE_CLEAR, 0x00
.equ                  DEF_GPIO_OUT_STATE_SET,  0x01



_start:               @configure GPIO as output
                      MOV        SP,   #0x8000                     @ stack pointer

                      LDR        R0,   =27                         @ assign gpio number
                      LDR        R1,   =DEF_GPIO_MODE_OUTPUT       @ output mode
                      BL         GPIO_Set_Mode                     @ call func to config

_loop_start:
                      @set GPIO
                      LDR        R0,   =27                         @ assign gpio number
                      BL         GPIO_Set_Output                   @ call gpio high
                      BL         delay                             @ call delay


                      @clear GPIO
                      LDR        R0,   =27                         @ assign gpio number
                      BL         GPIO_Clear_Output                 @ call gpio low
                      BL         delay                             @ call delay



                      B          _loop_start                       @ repeat


delay:
                      MOV        R2,   #0x400000                   @ assign delay count val
delay_loop:
                      SUBS       R2,   R2, #1                      @ subtract 1
                      BNE        delay_loop                        @ if not zero, repeat
                      BX         LR                                @ return





@ arg1(R0)->PinNumber, arg2(R1)->ModeVal
GPIO_Set_Mode:
_gpio_0_to_9: 
                      CMP        R0,   #9                          @ compare with 9
                      BHI        _gpio_10_to_19                    @ jump to next section 
                      LDR        R2,   =DEF_GPFSEL0_PHY            @ GPIO0~9 Func select
                      B          _gpio_mode_assign                 @ jump to assignment
_gpio_10_to_19: 
                      CMP        R0,   #19                         @ compare with 19
                      BHI        _gpio_20_to_29                    @ jump to next section 
                      LDR        R2,   =DEF_GPFSEL1_PHY            @ GPIO10~19 Func select
                      SUBS       R0,   R0, #10                     @ subtract pin-base(10)
                      B          _gpio_mode_assign                 @ jump to assignment
_gpio_20_to_29: 
                      CMP        R0,   #29                         @ compare with 29
                      BHI        _gpio_30_to_39                    @ jump to next section 
                      LDR        R2,   =DEF_GPFSEL2_PHY            @ GPIO20~29 Func select
                      SUBS       R0,   R0, #20                     @ subtract pin-base(20)
                      B          _gpio_mode_assign                 @ jump to assignment
_gpio_30_to_39: 
                      CMP        R0,   #39                         @ compare with 29
                      BHI        _gpio_40_to_49                    @ jump to next section 
                      LDR        R2,   =DEF_GPFSEL3_PHY            @ GPIO30~39 Func select
                      SUBS       R0,   R0, #30                     @ subtract pin-base(30)
                      B          _gpio_mode_assign                 @ jump to assignment
_gpio_40_to_49: 
                      CMP        R0,   #49                         @ compare with 29
                      BHI        _gpio_50_to_53                    @ jump to next section 
                      LDR        R2,   =DEF_GPFSEL4_PHY            @ GPIO40~49 Func select
                      SUBS       R0,   R0, #40                     @ subtract pin-base(40)
                      B          _gpio_mode_assign                 @ jump to assignment
_gpio_50_to_53:
                      CMP        R0,   #53                         @ compare with 29
                      BHI        _gpio_mode_exit                   @ jump to next section 
                      LDR        R2,   =DEF_GPFSEL5_PHY            @ GPIO50~53 Func select
                      SUBS       R0,   R0, #50                     @ subtract pin-base(50)
                      B          _gpio_mode_assign                 @ jump to assignment

_gpio_mode_assign:
                      MOV        R3,   #3                          @ set val 3
                      MULS       R0,   R3, R0                      @ (pin-offset)*3
                      LSL        R1,   R1, R0                      @ left shift mode val
                      LDR        R3,   =DEF_GPIO_MODE_MSK          @ load mask val
                      LSL        R3,   R3, R0                      @ offset masked val
                      MVN        R3,   R3                          @ invert all bits
                      LDR        R0,   [R2]                        @ fetch val of GPFSEL
                      AND        R0,   R0, R3                      @ clear mode bits
                      ORR        R0,   R0, R1                      @ config mode bits
                      STR        R0,   [R2]                        @ assign val

_gpio_mode_exit:
                      BX         LR                                @ return from func



@ Function for setting a gpio pin
@ arg1(R0)->PinNumber
GPIO_Set_Output:
_gpio_set_0_to_31: 
                      CMP        R0,   #31                         @ compare with 31
                      BHI        _gpio_set_32_to_53                @ jump to next section
                      LDR        R1,   =DEF_GPSET0_PHY             @ GPIO0~31 output state select
                      B          _gpio_set_assign                  @ jump to assignment
_gpio_set_32_to_53:   
                      CMP        R0,   #53                         @ compare with 53
                      BHI        _gpio_set_exit                    @ jump to exit
                      LDR        R1,   =DEF_GPSET1_PHY             @ GPIO0~9 Func select
                      SUBS       R0,   R0, #31                     @ subtract pin-base(31)
                      B          _gpio_set_assign                  @ jump to assignment
_gpio_set_assign:   
                      MOV        R2,   #1                          @ set val to 1
                      LSL        R2,   R2, R0                      @ offset masked val
                      LDR        R3,   [R1]                        @ load curr val
                      ORR        R3,   R3, R2                      @ config mode bits
                      STR        R3,   [R1]                        @ assign val
_gpio_set_exit:
                      BX         LR                                @ return from func




@ Function for clearing a gpio pin
@ arg1(R0)->PinNumber
GPIO_Clear_Output:
_gpio_clear_0_to_31: 
                      CMP        R0,   #31                         @ compare with 31
                      BHI        _gpio_clear_32_to_53              @ jump to next section
                      LDR        R1,   =DEF_GPCLR0_PHY             @ GPIO0~31 output state select
                      B          _gpio_clear_assign                @ jump to assignment
_gpio_clear_32_to_53:   
                      CMP        R0,   #53                         @ compare with 53
                      BHI        _gpio_clear_exit                  @ jump to exit
                      LDR        R1,   =DEF_GPCLR1_PHY             @ GPIO0~9 Func select
                      SUBS       R0,   R0, #31                     @ subtract pin-base(31)
                      B          _gpio_clear_assign                @ jump to assignment
_gpio_clear_assign:   
                      MOV        R2,   #1                          @ set val to 1
                      LSL        R2,   R2, R0                      @ offset masked val
                      LDR        R3,   [R1]                        @ load curr val
                      ORR        R3,   R3, R2                      @ config mode bits
                      STR        R3,   [R1]                        @ assign val
_gpio_clear_exit:
                      BX         LR                                @ return from func




