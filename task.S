.section .data
    buffer:
        .fill 256, 1, 0  
        
    filename:
        .asciz "wow.txt"
    
    file_content:
        .asciz "WOOOOOOOOOOOOOOOOOOOOOOOOW!!!!!\n"
    
    read_buffer:
        .fill 256, 1, 0
    
    newline:
    .asciz "\n"
    
.section .text
    .global _start

_start:
    ldr x0, =buffer     // Load buffer address into x0 
    mov x1, #256        // Set buffer size to 256 bytes 
    mov x8, #17         // getcwd
    svc #0              
    
    // Store recieved value
    mov x3, x0          
    
    // print the directory
    mov x0, #1          
    ldr x1, =buffer     
    mov x2, x3          // Length of the string (returned by getcwd)
    mov x8, #64         // Syscall number 64 is write
    svc #0              // Make the system call
    
    // print newline
    mov x0, #1
    ldr x1, =newline
    mov x2, #1 // 1 byte length
    mov x8, #64 //write
    svc #0

    mov x0, #-100
    ldr x1, =filename
    mov x2, #0x41 //Flags: O_CREAT | O_WRONLY | O_TRUNC (create, write-only, truncate)
    mov x3, #0644 // 0644 permissions
    mov x8, #56  //openat
    svc #0

    // save file descriptor in x19
    mov x19, x0


    //write to file
    mov x0, x19
    ldr x1, =file_content
    mov x2, #33 //length of file_content
    mov x8, #64 //write
    svc #0

    //close the file
    mov x0, x19
    mov x8, #57 //close
    svc #0

    //change file permissions 
    ldr x0, =filename
    mov x1, #0755 
    mov x8, #52 //chmod
    svc #0

    //open file for reading
    mov x0, #-100
    ldr x1, =filename
    mov x2, #0    // flags O_RDONLY (read-only)
    mov x8, #56 //openat
    svc #0

    //save file descriptor
    mov x19, x0

    //read from the file
    mov x0, x19
    ldr x1, =read_buffer
    mov x2, #256 //read 256 bytes max
    mov x8, #63
    svc #0

    //save those read bytes to x20
    mov x20, x0

    //close the file
    mov x0, x19
    mov x8, #57 //close
    svc #0

    // print read file_content
    mov x0, #1
    ldr x1, =read_buffer
    mov x2, x20 
    mov x8, #64
    svc #0

    mov x0, #1          // Exit status code 1
    mov x8, #93         // Syscall number 93 is exit
    svc #0              // Make the system call
