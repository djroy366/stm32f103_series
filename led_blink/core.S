.syntax unified
.cpu cortex-m0
.fpu softvfp  // As no Floating point Hardware, so software floating point is used
.thumb  // thumb instruction set is used

// Global memory locations.
//.global vtable  defined in vector_table.S
.global reset_handler

/*
 * The actual vector table.
 * Only the size of RAM and 'reset' handler are
 * included, for simplicity.
 */
.type vtable, %object
vtable:                  // This is the vextor table
    .word _estack        // word : 4 bytes
    .word reset_handler
.size vtable, .-vtable

/*
 * The Reset handler. Called on reset.
 * we’ll just load a recognizable hex value (0xDEADBEEF) into the r7 register, 
 * and then count up from 0 on the r0 register forever. In ‘Thumb’ assembly, that looks like this:
 *
 */

.type reset_handler, %function
reset_handler:
  // Set the stack pointer to the end of the stack.
  // The '_estack' value is defined in our linker script.
  LDR  r0, =_estack
  MOV  sp, r0

 // Initialize the `.data` section (copy from flash to RAM).
  MOVS r0, #0            // Clear r0 (offset for copying)
  LDR  r1, =_sdata       // Load the start address of .data in RAM
  LDR  r2, =_edata       // Load the end address of .data in RAM
  LDR  r3, =_sidata      // Load the start address of .data in flash
  B    copy_sidata_loop  // Jump to the copy loop

copy_sidata:
  LDR  r4, [r3, r0]      // Load a word from flash (sidata + offset)
  STR  r4, [r1, r0]      // Store the word into RAM (sdata + offset)
  ADDS r0, r0, #4        // Increment the offset by 4 bytes (word size)

copy_sidata_loop:
  ADDS r4, r0, r1        // Calculate current RAM address
  CMP  r4, r2            // Compare with the end address of .data
  BCC  copy_sidata       // Branch if not done copying

  // Zero out the `.bss` section.
  MOVS r0, #0            // Clear r0 (value to store in .bss)
  LDR  r1, =_sbss        // Load the start address of .bss
  LDR  r2, =_ebss        // Load the end address of .bss
  B    reset_bss_loop    // Jump to the zeroing loop

reset_bss:
  STR  r0, [r1]          // Store 0 into the current .bss address
  ADDS r1, r1, #4        // Increment to the next word in .bss

reset_bss_loop:
  CMP  r1, r2            // Compare the current address with .bss end
  BCC  reset_bss         // Branch if not done zeroing

  // Branch to the 'main' function to start execution.
  B    main
.size reset_handler, .-reset_handler
/* Previous main_loop
        // Set some dummy values. When we see these values
        // in our debugger, we'll know that our program
        // is loaded on the chip and working.
        LDR  r7, =0xDEADBEEF
        MOVS r0, #0   // # can be used to assign contant value(0-255), larger values need LDR command
        main_loop:
        // Add 1 to register 'r0'.
        ADDS r0, r0, #1
        // Loop back.
        B    main_loop
*/
