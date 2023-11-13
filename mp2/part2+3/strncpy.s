# stmcpy.s


.section .text

.global mystrncpy

mystrncpy:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi # Destination string (s)
    movl 12(%ebp), %esi  # Source string (ct)
    movl 16(%ebp), %ecx # Maximum number of characters to copy (n)

    xorl %eax, %eax    # Initialize EAX to 0

copy_loop:
    # Check if n is zero or we reached the end of the source string
    cmpl $0, %ecx
    jz end_copy

    # Load a character from the source string and store it in the destination string
    movb (%esi), %dl
    movb %dl, (%edi)

    # Increment source and destination pointers
    incl %esi
    incl %edi

    # Decrement the character count
    decl %ecx

    # Check for null-termination of the source string
    cmpb $0, %dl
    jz end_copy

    # Continue the loop
    jmp copy_loop

end_copy:
    movl 8(%ebp), %eax   # Set EAX to the address of the destination string (s)

    popl %ebp
    ret
    .end
