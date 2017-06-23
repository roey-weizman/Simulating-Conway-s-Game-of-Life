        
       
        extern WorldLength,WorldWidth;
        extern resume, end_co
        global scheduler
        
        


section .data

    num_gen: dd 0
    countTheRoutins: dd 0 
    frequency: dd 0 

section .text

scheduler:
    push ebp
    mov ebp,esp
    mov edi, dword [ebp+12]
    mov dword[frequency],edi
    mov edi, dword [ebp+8]
    mov dword[num_gen],edi
    
    xor eax,eax
    xor ebx,ebx
    
    ;calculate num of corutines
    pushad
    mov ax, word[WorldLength]
    mov bx, word[WorldWidth]
    mul bx
    mov dword[countTheRoutins],eax
    popad
    
    xor edx,edx ;scheduler loop counter(ebx)
    xor edi ,edi; counter to compare frequency(eax)
    
.generation_welcome_loop:
        mov  edi,0;counter to compare frequency(eax)
        mov  ebx,2 ; corutine of first cell(ebx)
.stage_1:
    call resume
    inc edi; print counter
    inc ebx;next corutine
    
    cmp edi, dword[frequency]
    jne .no_print_for_stage1    
    ;need to pass control to printer
    push ebx; want to save the corutine number before passing to printer
    mov ebx,1;printer corutine
    call resume
    xor edi,edi ;print counter is zero
    pop ebx ; get the right number of current routine to execute
    
.no_print_for_stage1:
    mov esi, dword[countTheRoutins]
    add esi,2
    cmp esi,ebx ;ask if its the last cell to work on
    jne .stage_1
    mov ebx,2 ; get first cell for next stage    

.stage_2:
    call resume
    inc edi; print counter
    inc ebx;next corutine
    
    cmp edi, dword[frequency]
    jne .no_print_for_stage2    
    ;need to pass control to printer
    push ebx; want to save the corutine number before passing to printer
    mov ebx,1;printer corutine
    call resume
    xor edi,edi ;print counter is zero
    pop ebx ; get the right number
    
.no_print_for_stage2:
    mov esi, dword[countTheRoutins]
    add esi,2
    cmp esi,ebx ;ask if its the last cell to work on
    jne .stage_2
    
.curr_generation_is_finished:
   inc edx
   cmp edx, dword[num_gen]
   jne .generation_welcome_loop
   
.end:
;need to pass the printer the control for the last printing
push  ebx
mov ebx,1
call resume
pop ebx

pop ebp
call end_co
        
        
        
    