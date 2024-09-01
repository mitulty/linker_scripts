# Variables for utilities
GCC       = arm-none-eabi-gcc
LD        = arm-none-eabi-ld
READELF   = arm-none-eabi-readelf
OBJDUMP   = arm-none-eabi-objdump
SYMBOL    = arm-none-eabi-nm

LS ?= no  

SRCS := $(wildcard *.c)
OBJS := $(SRCS:.c=.o)
TARGET = main

# variable for linker scrtip, map file and the readelf output
LD_SCRIPT   = $(TARGET).ld
LD_MAP      = $(TARGET).map
READELF_OUT = $(TARGET).txt

# object files our exploration depends on
# OBJ = main.o

# this is executed on running 'make'
all: $(READELF_OUT) mainobjdump symbolgen
	@

#genrates objdump of main.elf
mainobjdump: $(TARGET).elf
	$(OBJDUMP) -D $< > $<.s

#generates symbol
symbolgen: $(TARGET).elf
	$(SYMBOL) $< 

# generates the log
$(READELF_OUT): $(TARGET).elf
	$(READELF) -a $^ > $@

# output file
main.elf: $(OBJS) $(LD_SCRIPT)
ifeq ($(LS),yes)
# $(LD) -s -Bsymbolic -gc-sections -T$(LD_SCRIPT) -static -Map=$(LD_MAP) -o $@ $(OBJS)
	$(LD) -T$(LD_SCRIPT) -static -Map=$(LD_MAP) -o $@ $(OBJS)

else
	$(LD) -static -Map=$(LD_MAP) -o $@ $(OBJS)
endif

%.o: %.c
	$(GCC) -Wall -nostdlib -fno-builtin -ffreestanding -c $<
	$(OBJDUMP) -D $@ > $*.s

clean:
	rm -f *.o *.elf *.txt *.map *.log *.s

.PHONY: clean mainobjdump all
