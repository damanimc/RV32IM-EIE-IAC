main:
addi a1, zero, 0
addi a0, zero, 0xFF
addi t2, zero, 8
addi t1, zero, 0
nop
nop
nop
loop: 
beq a1, t2, delay 
addi a1, a1, 1
jal ra, sub 
beq zero, zero, loop

sub:
slli a0, a0, 1
nop
jalr ra, ra, 0

delay:
addi t1, t1, 1
bne t1, t2, delay

end:
beq zero, zero, main