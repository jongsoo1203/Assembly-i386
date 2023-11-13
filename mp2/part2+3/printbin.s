# printbin.s


.text
.global printbin

printbin:
    # Setup stack frame
    pushl %ebp
    movl %esp, %ebp

    xorl %eax, %eax
    xorl %edx, %edx     # Reset registers

    movb 8(%ebp), %dl   # Get the parameter

    xorl %esi, %esi     # Reset registers
    xorl %edi, %edi

    shrb $4, %dl         # Shift 4 to the right to get the high nibble
    call donibble       # Call donibble for the high half

    xorl %edx, %edx     # Reset %edx to get the second half
    movb 8(%ebp), %dl   # Get the second half

    andb $0xf, %dl      # Masking to get the low nibble

    movb $8, num        # Resetting 8 '1000' for bit-testing in donibble
    incl %esi           # Incrementing %esi to skip the space in outbin
    call donibble       # Call donibble for the second half

    movl $outbin, %eax  # Move the address of data to %eax to output
    movb $8, num        # Reset 8 '1000' to test multiple times in tutor

    # Remove stack frame
    movl %ebp, %esp
    popl %ebp

    ret

donibble:
    movl $4, %ecx    # Set the counter to loop four times

while:
    testb num, %dl  # Test bit from '1000' to '0001'
    je zero         # If ZF=1, jump

    movb $0x31, outbin(,%esi,1)  # Move '1' otherwise to outbin
    shrb num       # Shift right num to test the next bit
    incl %esi      # Increment esi to place the next '0/1' in outbin
    loop while     # Repeat loop, four times
    ret

zero:
    movb $0x30, outbin(,%esi,1)  # Move '0' to outbin
    shrb num       # Right shift to test the next bit
    incl %esi      # Increment esi to place the next '0/1' in outbin
    loop while     # Repeat four times, until ecx = 0

    ret

.data
outbin:
  .ascii "abcd efgh\n\0"  # Added newline and null terminator for correct output
num:
   .byte 8
