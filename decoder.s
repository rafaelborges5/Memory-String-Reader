.text
empty_string:    .asciz "%c"
.include "final.s"

.global main

# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 2 byte unknown                                         *
#   - 4 byte index                                           *
#   - 1 byte amount                                          *
#   - 1 byte character                                       *
# Parameters:                                                *
#   first: the address of the message to read                *
#   return: no return value                                  *
# ************************************************************
decode:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

        movq  %rdi, %r8                 # copy the initial address to r8 in order to create the stopping condition

        loop:
            movq $0, %rdx               # clear rdx
            movb 1(%rdi), %dl           # move the byte that contains the number of repetitions to rdx
            movq $0, %rsi               # clear rsi
            movb (%rdi), %sil           # move the byte that contains the character to rsi
            pushq %r8                   # push the value of r8 into the stack so it doesn't get overwriten
            call print_characters       # call the print_characters subroutine
            popq %r8                    # pop the original value of r8 back into r8
            movq $0, %rcx               # clear rcx
            movl 2(%rdi), %ecx          # move the four bytes that have the address of the next memory blocks to rcx
            shl $3, %rcx                # multiply the offset by 8, using the shifting operation
            movq %r8, %rdi              # reset rdi to the original address
            addq %rcx, %rdi             # add rdi with the offset calculeted in rcx to become the new address
            cmpq %r8, %rdi              # check if the next memory block has the same address as the first
            je   end_loop               # break from the loop if one cycle has already been completed
            jmp loop                    # jump to the next iteration of the loop            


        end_loop:


	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret                             # return from decode

print_characters:
 
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer
      
        movq $0, %rcx                   # initialize the loop counter

        loop1:
             cmpq %rcx, %rdx            # compare the loop counter to the repetitions stored in rsi
             je end_loop1               # break from the loop if counter => to the repetitions
             pushq %rdi                 # create temporary space in rdi for printf
             pushq %rcx                 # store rcx into the stack so it doesn't get overwriten when calling printf
             pushq %rdx                 # store rdx into the stack so it doesn't get overwriten when calling printf 
             pushq %rsi                 # store rsi into the stack so it doens't get overwriten when calling printf
                  
             movq $0, %rax              # no vector registers in use for printf
             movq $empty_string, %rdi   # load the empy_string address
             call printf                # call the printf routine

             popq %rsi                  # pop the original value of rsi back into rsi
             popq %rdx                  # pop the original value of rdx back into rdx
             popq %rcx                  # pop the original value of rdc back into rcx
             incq %rcx                  # increment the loop counter

             popq %rdi                  # restore the value that was in rdi
             jmp loop1                  # jump to the next iteration of the loop

        end_loop1:


	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
     	ret                             # return from print_characters
  
main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi  	# first parameter: address of the message
	call	decode			# call decode

	popq	%rbp			# restore base pointer location 
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program

