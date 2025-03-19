.syntax unified            // Use Unified Assembly Syntax for ARM processors
.cpu cortex-m0             // Specify the target CPU as Cortex-M0
.fpu softvfp               // Specify software-based floating-point (no hardware FPU)
.thumb                     // Use Thumb instruction set (mandatory for Cortex-M)

.global vtable             // Make the vector table symbol globally accessible
.global default_interrupt_handler // Make the default handler globally accessible

/*
 * The vector table.
 */
.type vtable, %object      // Define 'vtable' as an object (not a function)
.section .vector_table,"a",%progbits // Place the vector table in the .vector_table section
vtable:
  // Core exception handlers (positions 0-15)
  .word _estack            // Address of the stack pointer (SP) at reset (end of RAM)
  .word reset_handler      // Reset handler (entry point after power-on/reset)
  .word NMI_handler        // Non-Maskable Interrupt (NMI) handler
  .word hard_fault_handler // Hard fault handler (serious error)
  .word 0                  // Reserved (not used)
  .word 0                  // Reserved (not used)
  .word 0                  // Reserved (not used)
  .word 0                  // Reserved (not used)
  .word 0                  // Reserved (not used)
  .word 0                  // Reserved (not used)
  .word 0                  // Reserved (not used)
  .word SVC_handler        // Supervisor Call (SVC) handler (system service request)
  .word 0                  // Reserved (not used)
  .word 0                  // Reserved (not used)
  .word pending_SV_handler // Pending SV (Syscall/Exception) handler
  .word SysTick_handler    // SysTick timer interrupt handler

  // Peripheral interrupt handlers (positions 16-31)
  .word window_watchdog_IRQ_handler  // Window watchdog interrupt
  .word PVD_IRQ_handler              // Power Voltage Detector interrupt
  .word RTC_IRQ_handler              // Real-Time Clock interrupt
  .word flash_IRQ_handler            // Flash memory interrupt
  .word RCC_IRQ_handler              // Reset and Clock Control interrupt
  .word EXTI0_1_IRQ_handler          // External Interrupt (lines 0-1)
  .word EXTI2_3_IRQ_handler          // External Interrupt (lines 2-3)
  .word EXTI4_15_IRQ_handler         // External Interrupt (lines 4-15)
  .word 0                            // Reserved (not used)
  .word DMA1_chan1_IRQ_handler       // DMA1 Channel 1 interrupt
  .word DMA1_chan2_3_IRQ_handler     // DMA1 Channel 2 and 3 interrupt
  .word DMA1_chan4_5_IRQ_handler     // DMA1 Channel 4 and 5 interrupt
  .word ADC1_IRQ_handler             // ADC1 (Analog-to-Digital Converter) interrupt
  .word TIM1_break_IRQ_handler       // TIM1 Break interrupt
  .word TIM1_CC_IRQ_handler          // TIM1 Capture Compare interrupt
  .word TIM2_IRQ_handler             // TIM2 interrupt

  // Peripheral interrupt handlers (positions 32-47)
  .word TIM3_IRQ_handler             // TIM3 interrupt
  .word 0                            // Reserved (not used)
  .word 0                            // Reserved (not used)
  .word TIM14_IRQ_handler            // TIM14 interrupt
  .word 0                            // Reserved (not used)
  .word TIM16_IRQ_handler            // TIM16 interrupt
  .word TIM17_IRQ_handler            // TIM17 interrupt
  .word I2C1_IRQ_handler             // I2C1 (Inter-Integrated Circuit) interrupt
  .word 0                            // Reserved (not used)
  .word SPI1_IRQ_handler             // SPI1 (Serial Peripheral Interface) interrupt
  .word 0                            // Reserved (not used)
  .word USART1_IRQ_handler           // USART1 (Universal Synchronous/Asynchronous Receiver-Transmitter) interrupt
  .word 0                            // Reserved (not used)
  .word 0                            // Reserved (not used)
  .word 0                            // Reserved (not used)
  .word 0                            // Reserved (not used)

  // Boot configuration (position 48)
  #define boot_ram_base  0xF108F85F  // Boot RAM base address
  .word boot_ram_base               // Boot configuration entry

/*
 * Setup weak aliases for each exception handler to the
 * default handler. This allows overriding the default handler
 * by defining a strong handler elsewhere in the code.
 */
  .weak NMI_handler                 // Declare NMI handler as a weak reference
  .thumb_set NMI_handler,default_interrupt_handler // Default to default_interrupt_handler

  .weak hard_fault_handler
  .thumb_set hard_fault_handler,default_interrupt_handler

  .weak SVC_handler
  .thumb_set SVC_handler,default_interrupt_handler

  .weak pending_SV_handler
  .thumb_set pending_SV_handler,default_interrupt_handler

  .weak SysTick_handler
  .thumb_set SysTick_handler,default_interrupt_handler

  .weak window_watchdog_IRQ_handler
  .thumb_set window_watchdog_IRQ_handler,default_interrupt_handler

  .weak PVD_IRQ_handler
  .thumb_set PVD_IRQ_handler,default_interrupt_handler

  .weak RTC_IRQ_handler
  .thumb_set RTC_IRQ_handler,default_interrupt_handler

  .weak flash_IRQ_handler
  .thumb_set flash_IRQ_handler,default_interrupt_handler

  .weak RCC_IRQ_handler
  .thumb_set RCC_IRQ_handler,default_interrupt_handler

  .weak EXTI0_1_IRQ_handler
  .thumb_set EXTI0_1_IRQ_handler,default_interrupt_handler

  .weak EXTI2_3_IRQ_handler
  .thumb_set EXTI2_3_IRQ_handler,default_interrupt_handler

  .weak EXTI4_15_IRQ_handler
  .thumb_set EXTI4_15_IRQ_handler,default_interrupt_handler

  .weak DMA1_chan1_IRQ_handler
  .thumb_set DMA1_chan1_IRQ_handler,default_interrupt_handler

  .weak DMA1_chan2_3_IRQ_handler
  .thumb_set DMA1_chan2_3_IRQ_handler,default_interrupt_handler

  .weak DMA1_chan4_5_IRQ_handler
  .thumb_set DMA1_chan4_5_IRQ_handler,default_interrupt_handler

  .weak ADC1_IRQ_handler
  .thumb_set ADC1_IRQ_handler,default_interrupt_handler

  .weak TIM1_break_IRQ_handler
  .thumb_set TIM1_break_IRQ_handler,default_interrupt_handler

  .weak TIM1_CC_IRQ_handler
  .thumb_set TIM1_CC_IRQ_handler,default_interrupt_handler

  .weak TIM2_IRQ_handler
  .thumb_set TIM2_IRQ_handler,default_interrupt_handler

  .weak TIM3_IRQ_handler
  .thumb_set TIM3_IRQ_handler,default_interrupt_handler

  .weak TIM14_IRQ_handler
  .thumb_set TIM14_IRQ_handler,default_interrupt_handler

  .weak TIM16_IRQ_handler
  .thumb_set TIM16_IRQ_handler,default_interrupt_handler

  .weak TIM17_IRQ_handler
  .thumb_set TIM17_IRQ_handler,default_interrupt_handler

  .weak I2C1_IRQ_handler
  .thumb_set I2C1_IRQ_handler,default_interrupt_handler

  .weak SPI1_IRQ_handler
  .thumb_set SPI1_IRQ_handler,default_interrupt_handler

  .weak USART1_IRQ_handler
  .thumb_set USART1_IRQ_handler,default_interrupt_handler

.size vtable, .-vtable  // Calculate the size of the vector table

/*
 * The default interrupt handler.
 * This is an infinite loop, indicating an unhandled interrupt.
 */
.section .text.default_interrupt_handler,"ax",%progbits
default_interrupt_handler:
  default_interrupt_loop:
    B default_interrupt_loop      // Branch to itself (infinite loop)
.size default_interrupt_handler, .-default_interrupt_handler

