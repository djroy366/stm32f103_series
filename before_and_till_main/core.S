.syntax unified
.cpu cortex-m0
.fpu softvfp  // As no Floating point Hardware, so software floating point is used
.thumb  // thumb instruction set is used

// Global memory locations.
.global vtable
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
.size reset_handler, .-reset_handler
