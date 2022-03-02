// Replace this file with your own implementation
    .arch armv8-a
    .global intmul
 
intmul:
 
    stp    x29, x30, [sp,-48]!
    stp    x19, x20, [sp, 16]
    stp    x21, x22, [sp, 32]
   
    mov x19, x0  //a
    mov x20, x1  //b
    cmp x20, x19
    bge swap

back:
    mov x22, 0 //total
   
    cmp x19, #0
    beq zero
 
    cmp x20, #0
    beq zero
    bge loop
 
    cmp x19, #0
    bge loop2
 
    b loop3
   
swap:
   mov x8, x19
   mov x19, x20
   mov x20, x8
   b back

loop:
    // add a to total
    mov x0, x22
    mov x1, x19
    bl intadd
    mov x22, x0
   
    //subtract 1 from b
    mov x0, x20
    mov x1, 1
    sub x0, x0, x1
    mov x20, x0
 
    cmp x20, #0
    b.eq finish
    b loop
   
loop2:
    // add a to total
    mov x0, x22
    mov x1, x19
    bl intadd
    mov x22, x0
   
    //subtract 1 from b
    mov x0, x20
    mov x1, 1
    bl intadd
    mov x20, x0
 
    cmp x20, #0
    b.eq finish
    b loop2
 
loop3:
    // add a to total
    mov x0, x22
    mov x1, x19
    sub x0, x0, x1
    mov x22, x0
   
    //subtract 1 from b
    mov x0, x20
    mov x1, 1
    bl intadd
    mov x20, x0
 
    cmp x20, #0
    b.eq finish
    b loop3
 
zero:
    mov x22, #0
    b finish
 
 
finish:
    mov x0, x22
    ldp    x19, x20, [sp, 16]
    ldp    x21, x22, [sp, 32]
    ldp    x29, x30, [sp], 48    
    ret
