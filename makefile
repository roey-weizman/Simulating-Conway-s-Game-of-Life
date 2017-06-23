CC		:=	gcc
CC_FLAGS	:=	-m32
ASM		:=	nasm
ASM_FLAGS	:=	-f elf 



all: clean ass3

ass3:	
	$(ASM) $(ASM_FLAGS)  printer.s -o printer.o
	$(ASM) $(ASM_FLAGS)  coroutines.s -o coroutines.o
	$(ASM) $(ASM_FLAGS)  scheduler.s -o scheduler.o
	$(ASM) $(ASM_FLAGS)  ass3.s -o ass3.o
	gcc -m32 -g -Wall -c -o cell.o cell.c
	$(CC) $(CC_FLAGS) ass3.o cell.o  coroutines.o printer.o scheduler.o -o ass3

#tell make that "clean" is not a file name!
.PHONY: clean

#Clean the build directory
clean: 
	rm -f *.o ass3
	echo clean done