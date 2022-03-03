// Replace this file with your own implementation
    .arch armv8-a
    .global intmul
 
intmul:
 
    stp    x29, x30, [sp,-48]!
    stp    x19, x20, [sp, 16]
    stp    x21, x22, [sp, 32]
    
    mov    x19, x0  //a
    mov    x20, x1  //b
    mov    x23, 0 // answer 

loop:
    cmp x20, 0
    b.eq finish


    //  if (m % 2 == 1)                
    and    x25, x20, 1
    cmp    x25, 1
    beq    odd

even:
		// count++;
    //    m /= 2;
    lsl x19, x19, 1
    lsr x20, x20, 1
    b  loop

odd:
    //         ans += n << count;
    mov x0, x23
    mov x1, x19
    bl intadd
    mov x23, x0
    
    mov x0, x20
    mov x1, -1
    bl intadd
	  mov x20, x0
    b even
	
    
finish:
    mov    x0, x23
    ldp    x19, x20, [sp, 16]
    ldp    x21, x22, [sp, 32]
    ldp    x29, x30, [sp], 48    
    ret