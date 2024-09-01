/*
- A linker script controls every link. Such a script is written in the linker command language. The main purpose of the linker script is to describe how the sections in the input files should be mapped
  into the output file, and to control the memory layout of the output file. However, when necessary, the linker script can also direct the linker to perform many other operations, using the linker
  commands.
- The sections .text, .data., .bss are the default executable sections which are present in an object file. -d flag in objdump/arm-none-eabi-objdump only dumps the executable sections present in the 
  object file, whereas the -D flag dumps all the sections which may include sections like .comment, .note.gnu.property, .eh_frame, .ARM.attributes,etc. All the sections will have the starting address 
  of 0x0. In the main excutable file the sections will be placed according the linker script. All the unknows symbols in an object file will have a value of 0x0 and will be resolved by the linker.
- The three main tasks of a linker are: Resolution of symbols, grouping of sections and placement of sections to generate an executable. The linker script is required for grouping and placements of the 
  sections in the executable.
- Linker script is a collection of statements. These statements set a particular option. Some of these are used to select input files, group the input sections of the file and name the output sections
  of the file. Two statements SECTIONS and MEMORY have fundamental and prevasive impact on the linking process. MEMORY is optional and if not give linker will assume the default memory:{0x00000000 - 
  0xffffffff}.
- Expressions: All expressions are evaluated as integers (either long or unsigned long). All constants are integers. All C arithmetic operations are provided. Global variables can be created, defined 
  and referenced. Special in-built functions can be called.
- Linker performs "lazy evaluation" for expressions, i.e., calculate an expression when absolute necessary.
- Values: These are always integers which can be expresses as Decimal, Octal (0 as a prefix), Hexadecimal (0x as a prefix) and Negative (-10 ). Suffixes like K/k for 10^3, M/m for 10^6 and G/g for 10^9 
  can be used for scaling.
- Symbol Names: Unless quoted, these should start wih a letter, underscore or a point. They may include any letters, underscore, digits, points and hypens. Unquoted symbol names must not conflict with 
  any keyword.
- Assignments define symbols. These can be:
                                                    Symbol = expression;
                                                    Symbol &= expression;
                                                    Symbol [+,-,*,/]= expression;
  These may only appear at the end at the ROOT of an expression and end using the ;.
- The special linker variable dot `.' always contains the current output location counter. Since the . always refers to a location in an output section, it must always appear in an expression within a 
  SECTIONS command. The . symbol may appear anywhere that an ordinary symbol is allowed in an expression, but its assignments have a side effect. Assigning a value to the . symbol will cause the 
  location counter to be moved. This may be used to create holes in the output section. The location counter may never be moved backwards.
                                                    SECTIONS
                                                    {
                                                      output :
                                                      {
                                                      file1(.text)
                                                      . = . + 1000;
                                                      file2(.text)
                                                      . += 1000;
                                                      file3(.text)
                                                      } = 0x1234;
                                                    } 
  The file1 is located at the beginning of the output section, then there is a 1000 byte gap. Then file2 appears, also with a 1000 byte gap following before file3 is loaded. The notation `= 0x1234' 
  specifies what data to write in the gaps.
                                                    SECTIONS
                                                    {
                                                            . = 0x10;
                                                            label_1 = .;
                                                            custom_section : {
                                                                    . = 0x20;
                                                                    label_2 = . ;
                                                                    label_3 = ABSOLUTE(.) ;
                                                                    *(.text) ;
                                                            }
                                                    }
                    0000000000000010 T label_1
                    0000000000000030 T label_2
                    0000000000000030 A label_3
- The "."" actually refers to the byte offset from the start of the current containing object. Normally this is the SECTIONS statement, whose start address is 0, hence the "." can be used as an absolute
  address. If the "." is used inside a section description however, it refers to the byte offset from the start of that section, not an absolute address. Thus in a script like this:
                                                            SECTIONS
                                                            {
                                                                . = 0x100
                                                                .text: {
                                                                  *(.text)
                                                                  . = 0x200
                                                                }
                                                                . = 0x500
                                                                .data: {
                                                                  *(.data)
                                                                  . += 0x600
                                                                }
                                                            }
  The ‘.text’ section will be assigned a starting address of 0x100 and a size of exactly 0x200 bytes, even if there is not enough data in the ‘.text’ input sections to fill this area. (If there is too 
  much data, an error will be produced because this would be an attempt to move . backwards). The ‘.data’ section will start at 0x500 and it will have an extra 0x600 bytes worth of space after the end 
  of the values from the ‘.data’ input sections and before the end of the ‘.data’ output section itself.
- Setting symbols to the value of the location counter outside of an output section statement can result in unexpected values if the linker needs to place orphan sections. For example, given the 
  following:
                                                            SECTIONS
                                                            {
                                                                start_of_text = . ;
                                                                .text: { *(.text) }
                                                                end_of_text = . ;

                                                                start_of_data = . ;
                                                                .data: { *(.data) }
                                                                end_of_data = . ;
                                                            }

  If the linker needs to place some input section, e.g. .rodata, not mentioned in the script, it might choose to place that section between .text and .data. You might think the linker should place 
  .rodata on the blank line in the above script, but blank lines are of no particular significance to the linker. As well, the linker doesn’t associate the above symbol names with their sections. Instead, it assumes that all assignments or other statements belong to the 
  previous output section, except for the special case of an assignment to .. i.e., the linker will place the orphan .rodata section as if the script was written as follows:
                                                            SECTIONS
                                                            {
                                                                start_of_text = . ;
                                                                .text: { *(.text) }
                                                                end_of_text = . ;

                                                                start_of_data = . ;
                                                                .rodata: { *(.rodata) }
                                                                .data: { *(.data) }
                                                                end_of_data = . ;
                                                            }
  This may or may not be the script author’s intention for the value of start_of_data. One way to influence the orphan section placement is to assign the location counter to itself, as the linker assumes that an assignment to . is setting the start address of a following output section and thus should be 
  grouped with that section. So you could write:
                                                            SECTIONS
                                                            {
                                                                start_of_text = . ;
                                                                .text: { *(.text) }
                                                                end_of_text = . ;

                                                                . = . ;
                                                                start_of_data = . ;
                                                                .data: { *(.data) }
                                                                end_of_data = . ;
                                                            }
  Now, the orphan .rodata section will be placed between end_of_text and start_of_data.
- Placement of assignment statements:
    1. As commands in their own right in the linker script.
    2. As independent statements with in a SECTIONS command.
    3. As a part of the contents of section defintion in a section command.
  Rules 1 and 2 will define a symbol with an absolute address and rule 3 will deine a symbol whose address is relative to a particular section.
- Type of a symbol: Each symbol has an absolute type associated with it based  on the assignment of value to symbol/variable. The type can be Relocatable or Absoulte. An absoulte type means it has the 
  same value in the output file as in the linker script. A relocatable type means that the value is a fixed offset from base of the section.
*/

MEMORY {
        MEM : org = 0x0000 , l = 0xA000
        ROM : org = 0xA000 , len = 0x1000
        RAM : org = 0xC000 , len = 4k
        FLASH : ORIGIN = 0xE000 , LENGTH = 8M
}

_this.is.a.variable = 10;
" this is ok" = 045;
"SECTIONS" = 0x23;
a = 140 ;
SECTIONS {
    b = 14 ;
    current_locator_counter = . ;
    . = 0x1000;
    current_locator_counter = . ;
    .text : {
    current_locator_counter = . ;
        c = a + b ;
        d = a - b ;
        e = a / b ;
        f = a % b ;
        /*. = 0x1000;*/ /* This will shift the region by 0x1000 relative to ROM start address and will create a hole in the memory. Since the size is 0x1000,
                        ROM will overflow.*/
        . = 0x100;
        _start_text_ = . ;
        *(.text)
        _end_text_ = . ;
        e = a + .;
    } > ROM

    .data :  {
        _start_data_mysection_ = . ; 
        *(.mysection)
        _end_data_mysection_ = . ;
        . = _end_data_mysection_ + 0x100;  /*Creating a hole in the memory.*/
        /* . = . + 0x100 ; will give the same behaviour */
        /*. =  0x100 ;/* This moves . by 0x100 w.r.t to start of the .data section and hence the 0xf8 bytes will be filled as 0x8 bytes are occupied by .mysection. */ 
        _start_data_section_ = . ; 
        *(.data)
        _end_data_section_ = . ;
    } > RAM AT > ROM

    /DISCARD/ : 
    {
         *(*)
    }
}