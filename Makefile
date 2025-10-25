all:
	arm-none-eabi-as main.S -o main.o
	arm-none-eabi-ld main.o -T linker.ld -o kernel.elf
	arm-none-eabi-objcopy kernel.elf -O binary kernel.img
clean:
	rm -f *.o *.elf *.img