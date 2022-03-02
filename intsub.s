    // intsub function in this file

    .arch armv8-a
    .global intsub

intsub:
    stp x29,x30,[sp,-32]!
    stp x19,x20,[sp,16]
    mvn x19,x0
    sxtw x0,w0
    sxtw x1,w1

loop:
    EOR x0,x0,x1
    AND x1,x19,x1
    LSL x1,x1,1
    cmp x1,0
    bne loop
endif:
    ldp x19,x20,[sp,16]
    ldp x29,x30,[sp],32
    ret

