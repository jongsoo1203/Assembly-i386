.globl count

count:
    pushl %ebp          # Save the old base pointer
    movl %esp, %ebp     # Set the new base pointer
    movl 8(%ebp), %esi  # %esi will point to the string
    movb 12(%ebp), %al  # %al (lower byte of %eax) will hold the character to be counted
    xorl %ecx, %ecx     # Clear the character count in %ecx

count_loop:
    movb (%esi), %dl    # Load a byte from the string into %dl(the users' input)
    testb %dl, %dl      # Test if the byte is null (end of string)
    je end_count        # If it's the end of the string, exit the loop
    cmpb %al, %dl       # Compare the loaded character with the target character
    je increment_count  # If they do match, jump to increment_count
    incl %esi           # Move to the next character in the string
    jmp count_loop      # go back to the count_loop

increment_count:
    incl %ecx           # Increment the character count in %ecx
    incl %esi           # Move to the next character in the string
    jmp count_loop      # Jump back to the beginning of the loop

end_count:
    movl %ecx, %eax     # Move the character count to %eax (return value)
    popl %ebp           # Restore the old base pointer
    ret                # Return from the function
