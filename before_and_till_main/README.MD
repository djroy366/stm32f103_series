
Package Manager : gcc-arm-none-eabi and gdb-arm-none-eabi

Compiled with : arm-none-eabi-gcc -x assembler-with-cpp -c -O0 -mcpu=cortex-m0 -mthumb -Wall core.S -o core.o

Linked with : arm-none-eabi-gcc core.o -mcpu=cortex-m0 -mthumb -Wall --specs=nosys.specs -nostdlib -lgcc -T./stm32f103.ld -o main.elf
            
            * -T is to provide the linker script


nm main.elf gives: 
                    08000000 t $d
                    08000014 t $d
                    08000008 t $t
                    20001000 A _estack
                    08000010 t main_loop
                    08000009 T reset_handler
                    08000000 T vtable


Flash and Debug :  st-util running in another termminal (this creates the connection)
                   in Another termminal
                    * arm-none-eabi-gdb main.elf (gdb will open)
                    * target extended-remote :4242
                    * load (this will load up the main.elf)

                    * continue (will run the program)
                    * info registers (this will show the register values)


Updated the Linker script, Added vector_table and also the code to copy the memory segments from flash to RAM in core.S with main code's memory sections also commented it.


Updated the Makefile, Also Added /build directory to the .gitignore as it's not relevent
