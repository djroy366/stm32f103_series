/* Define the end of RAM and limit of stack memory */
/* (4KB SRAM on the STM32F031x6 line, 4096 = 0x1000) */
/* (RAM starts at address 0x20000000) */


_estack = 0x20001000; /* This represent end of program stack, hence -estack*/


/* Set minimum size for stack and dynamic memory. */
/* (The linker will generate an error if there is
 * less than this much RAM leftover.) */
/* (1KB) */
_Min_Leftover_RAM = 0x400;

MEMORY
{
    FLASH ( rx )      : ORIGIN = 0x08000000, LENGTH = 32K
    RAM ( rxw )       : ORIGIN = 0x20000000, LENGTH = 4K
}

SECTIONS                  /* Start defining the memory layout using the linker script. */
{
  /* The vector table goes at the start of flash. */
  .vector_table :         /* Define the output section for the interrupt vector table. */
  {
    . = ALIGN(4);         /* Align the current address to a 4-byte boundary. */
    KEEP (*(.vector_table)) /* Include the `.vector_table` section from input files
                               and ensure it's not discarded, even during garbage collection. */
    . = ALIGN(4);         /* Re-align to a 4-byte boundary after adding the vector table. */
  } >FLASH                /* Place the `.vector_table` section in the FLASH memory region. */

  /* The 'text' section contains the main program code. */
  .text :                 /* Define the output section for program code. */
  {
    . = ALIGN(4);         /* Align the current address to a 4-byte boundary. */
    *(.text)              /* Include the `.text` section from all input object files. */
    *(.text*)             /* Include all sections whose names start with `.text`. */
    . = ALIGN(4);         /* Re-align to a 4-byte boundary after adding the `.text` sections. */
  } >FLASH                /* Place the `.text` section in the FLASH memory region. */

  /* The 'rodata' section contains read-only data,
   * constants, strings, information that won't change. */
  .rodata :               /* Define the output section for read-only data. */
  {
    . = ALIGN(4);         /* Align the current address to a 4-byte boundary. */
    *(.rodata)            /* Include the `.rodata` section from all input object files. */
    *(.rodata*)           /* Include all sections whose names start with `.rodata`. */
    . = ALIGN(4);         /* Re-align to a 4-byte boundary after adding `.rodata` sections. */
  } >FLASH                /* Place the `.rodata` section in the FLASH memory region. */

  /* The 'data' section is space set aside in RAM for
   * things like variables, which can change. */
  _sidata = .;            /* Mark the start address of the `.data` section in FLASH. */
  .data : AT(_sidata)     /* Define the output section for writable data and specify that it
                             is loaded from the `_sidata` address in FLASH. */
  {
    . = ALIGN(4);         /* Align the current address to a 4-byte boundary. */
    _sdata = .;           /* Mark the start of the `.data` section in RAM. */
    *(.data)              /* Include the `.data` section from all input object files. */
    *(.data*)             /* Include all sections whose names start with `.data`. */
    _edata = .;           /* Mark the end of the `.data` section in RAM. */
    . = ALIGN(4);         /* Re-align to a 4-byte boundary after adding `.data` sections. */
  } >RAM                  /* Place the `.data` section in the RAM memory region. */

  /* The 'bss' section is similar to the 'data' section,
   * but its space is initialized to all 0s at the
   * start of the program. */
  .bss :                  /* Define the output section for uninitialized data. */
  {
    . = ALIGN(4);         /* Align the current address to a 4-byte boundary. */
    _sbss = .;            /* Mark the start of the `.bss` section in RAM. */
    *(.bss)               /* Include the `.bss` section from all input object files. */
    *(.bss*)              /* Include all sections whose names start with `.bss`. */
    *(COMMON)             /* Include common symbols (uninitialized global variables). */
    . = ALIGN(4);         /* Re-align to a 4-byte boundary after adding `.bss` sections. */
    _ebss = .;            /* Mark the end of the `.bss` section in RAM. */
  } >RAM                  /* Place the `.bss` section in the RAM memory region. */

  /* Space set aside for the application's heap/stack. */
  .dynamic_allocations :  /* Define the output section for dynamic memory allocations. */
  {
    . = ALIGN(4);         /* Align the current address to a 4-byte boundary. */
    _ssystem_ram = .;     /* Mark the start of the heap/stack section in RAM. */
    . = . + _Min_Leftover_RAM; /* Allocate a minimum amount of RAM (`_Min_Leftover_RAM`)
                                  for the heap and stack. */
    . = ALIGN(4);         /* Re-align to a 4-byte boundary after allocating dynamic memory. */
    _esystem_ram = .;     /* Mark the end of the heap/stack section in RAM. */
  } >RAM                  /* Place the `.dynamic_allocations` section in the RAM memory region. */
}

