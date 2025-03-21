# Target binary name
TARGET = main

# Directory structure for build output
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin

# Ensure directories exist
$(shell mkdir -p $(OBJ_DIR) $(BIN_DIR))

# Define the linker script and chip architecture
LD_SCRIPT = stm32f103.ld
MCU_SPEC  = cortex-m0

# Toolchain definitions
TOOLCHAIN = /usr
CC = $(TOOLCHAIN)/bin/arm-none-eabi-gcc
AS = $(TOOLCHAIN)/bin/arm-none-eabi-as
LD = $(TOOLCHAIN)/bin/arm-none-eabi-ld
OC = $(TOOLCHAIN)/bin/arm-none-eabi-objcopy
OD = $(TOOLCHAIN)/bin/arm-none-eabi-objdump
OS = $(TOOLCHAIN)/bin/arm-none-eabi-size

# Include directories
INCLUDE_DIRS = ./include ./lib
CFLAGS = -mcpu=$(MCU_SPEC) -mthumb -Wall -g
CFLAGS += $(addprefix -I,$(INCLUDE_DIRS))  
CFLAGS += --specs=nosys.specs

# Assembler directives
ASFLAGS = -mcpu=$(MCU_SPEC) -mthumb -Wall -c -O0

# Linker flags
LFLAGS = -mcpu=$(MCU_SPEC) -mthumb -Wall --specs=nosys.specs -nostdlib -lgcc -T$(LD_SCRIPT)

# Source files
VECT_TBL = vector_table.S
AS_SRC   = core.S
C_SRC    = main.c

# Object files
OBJS = $(OBJ_DIR)/vector_table.o $(OBJ_DIR)/core.o $(OBJ_DIR)/main.o

# Default rule
.PHONY: all
all: $(BIN_DIR)/$(TARGET).bin

# Assemble `.S` files
$(OBJ_DIR)/%.o: %.S
	@mkdir -p $(dir $@)
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

# Compile `.c` files
$(OBJ_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

# Link objects into an ELF file
$(BIN_DIR)/$(TARGET).elf: $(OBJS)
	@mkdir -p $(dir $@)
	$(CC) $^ $(LFLAGS) -o $@

# Convert ELF to binary
$(BIN_DIR)/$(TARGET).bin: $(BIN_DIR)/$(TARGET).elf
	$(OC) -S -O binary $< $@
	$(OS) $<  

# Clean build files
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)


# Define CPPCHECK tool (update path if needed)
CPPCHECK = cppcheck  

.PHONY: CPPCHECK

CPPCHECK:
	$(CPPCHECK) --quiet --enable=all --error-exitcode=1 --inline-suppr -I $(INCLUDE_DIRS) $(wildcard *.c) 

