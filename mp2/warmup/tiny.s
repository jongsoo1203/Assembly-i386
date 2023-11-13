# tiny.s: mp2warmup program
#, ;, /* */ comment symbols
# as --32 -al -o tiny.o tiny.s

        .globl _start
_start:
	movl $8, %eax
	addl $0x3, %eax
	movl %eax, 0x200
	int $3 # to trap back to Tutor at the end
   	# to tell the assembler that this is the 
	# end of the code to be assembled.
	.end  

