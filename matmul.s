////////////////////////////////////////////////////////////////////////////////
// You're implementing the following function in ARM Assembly
//! C = A * B
//! @param C          result matrix
//! @param A          matrix A 
//! @param B          matrix B
//! @param hA         height of matrix A
//! @param wA         width of matrix A, height of matrix B
//! @param wB         width of matrix B
//
//  Note that while A, B, and C represent two-dimensional matrices,
//  they have all been allocated linearly. This means that the elements
//  in each row are sequential in memory, and that the first element
//  of the second row immedialely follows the last element in the first
//  row, etc. 
//
//void matmul(int* C, const int* A, const int* B, unsigned int hA, 
//    unsigned int wA, unsigned int wB)
//{
//  for (unsigned int i = 0; i < hA; ++i)
//    for (unsigned int j = 0; j < wB; ++j) {
//      int sum = 0;
//      for (unsigned int k = 0; k < wA; ++k) {
//        sum += A[i * wA + k] * B[k * wB + j];
//      }
//      C[i * wB + j] = sum;
//    }
//}
////////////////////////////////////////////////////////////////////////////////

	.arch armv8-a
	.global matmul
matmul:
    // x19 is pointer to first element of result Matrix "C"
    // x20 is pointer to first element of Matrix "A"	
    // x21 is pointer to first element of Matrix "B"
    // x22 is height of Matrix "A": "hA"
    // x23 is height of width of Matrix "A": "wA"
    // x24 is height of width of Matrix "B": "wB" 
    // x25 for "sum"
    // x26 for loop 1 : "i"
    // x27 for loop 2 : "j"
    // x28 for loop 3 : "k"

    stp    x29, x30, [sp,-128]!
    stp    x19, x20, [sp, 16]
    stp    x21, x22, [sp, 32]
    stp    x23, x24, [sp, 48]
    stp    x25, x26, [sp, 64]
    stp    x27, x28, [sp, 80]


    mov    x19, x0
    mov    x20, x1
    mov    x21, x2
    mov    x22, x3
    mov    x23, x4
    mov    x24, x5

    mov    x26, xzr // setting loop variables to 0

iLoop:
    cmp    x26, x22
    b.eq   endILoop  
    mov    x27, xzr

jLoop:
    cmp    x27, x24
    b.eq   endJLoop
    mov    x25, xzr
    mov    x28, xzr
    
kLoop:
    cmp    x28, x23
    b.eq   endKLoop
    
    // sum += A[i * wA + k] * B[k * wB + j];
    mov    x0, x26
    mov    x1, x23

    bl     intmul // i * wA
    //mul    x0, x1, x0

    mov	   x1, x28 
   
    bl     intadd // (i * wA) + k == x0 + x1
    //add    x0, x1, x0

    mov    x8, x0 // storing index result in temp x8
    mov    x0, x28 // moving k to x0
    mov    x1, x24 // moving wB to x1

    bl     intmul // k * wB
    //mul    x0, x1, x0

    mov    x1, x27 // moving j to x1

    bl     intadd // (k * wB) + j == x0 + x1
    //add    x0, x1, x0

    mov    x9, x0 // storing result index in temp x9
    
    mov    x1, #4
    
    mul    x8, x8, x1
    mul    x9, x9, x1    



    add    x8, x20, x8
    add    x9, x21, x9   

    ldr  w0, [x8]  // loading values from matrix by index offset
    ldr  w1, [x9]
    
    bl     intmul  //  A[i * wA + k] * B[k * wB + j];
    //mul    x0, x1, x0


    add    x25, x25, x0 // sum += above
    
    // k++
    add    x28, x28, #1
    b      kLoop
    
endKLoop:
    //C[i * wB + j] = sum;
    mov    x0, x26
    mov    x1, x24
    
    bl     intmul // i * wB
    //mul    x0, x0, x1

    mov    x1, x27 
    
    bl     intadd // previous value + j
    //add    x0, x1, x0   
    
    mov    x1, #4
    mul    x0, x0, x1 
    str    w25, [x19, x0] // loads to C[]
    
    // j++
    add    x27, x27, #1
    b      jLoop
    
endJLoop:
    // i++
    add    x26, x26 ,#1
    b      iLoop
    
endILoop:
    mov    x0, x19
    
    ldp    x19, x20, [sp, 16]
    ldp    x21, x22, [sp, 32]
    ldp    x23, x24, [sp, 48]
    ldp    x25, x26, [sp, 64]
    ldp    x27, x28, [sp, 80]
    ldp    x29, x30, [sp], 128  

    ret
 
