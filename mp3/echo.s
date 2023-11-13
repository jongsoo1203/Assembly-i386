# echo.s

.text
.globl _echo

_echo:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx

    movl 8(%ebp), %edx  # Load comport pointer into edx
    movb 12(%ebp), %bl  # Load escape character into bl

.loop:
    inb (%dx), %al     # Read a character from the COM port
    outb %al, %dx      # Echo the character back

    cmpb %bl, %al      # Compare the character with the escape character
    je .done            # If they match, exit the loop

    jmp .loop           # Otherwise, continue looping

.done:
    popl %ebx
    popl %ebp
    ret
    .end
