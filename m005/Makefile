TARGET=m005
SOURCES=changeversion.S ../f005/hookmain.S ../f005/newmenu.S ../f002/removerandomxor.S ../f002/serialdumpmemory.S ../f002/fixknobscaling.S 

FWUTILS=python3 ../../buttshock-et312-firmware/scripts/fw-utils.py

OBJECTS=$(SOURCES:.S=.o)
ASFLAGS=-mmcu=atmega16
LDFLAGS=-mavr5

all: $(SOURCES) $(TARGET)

$(TARGET).fwpatch: $(TARGET).elf 
	avr-objdump -D $(TARGET).elf > $(TARGET).fwpatch

$(TARGET): $(TARGET).fwpatch
# patch the firmware based on our asm and patches
	$(FWUTILS) -i ../../buttshock-et312-firmware/firmware/312-16-decrypted.bin -o $(TARGET).bin -p $(TARGET).fwpatch
# add checksum and convert ready to upload
	$(FWUTILS) -i $(TARGET).bin -e -o $(TARGET).upg

$(TARGET).elf: $(OBJECTS)
	avr-ld $(LDFLAGS) -o $(TARGET).elf $(OBJECTS)

.S.o:
	avr-as $(ASFLAGS) $< -o $@

clean:
	rm -f $(TARGET).bin $(TARGET).upg $(TARGET).elf *.o
