
global _start, countTheRoutins, WorldWidth, WorldLength, main, frequency , num_gen
extern init_co, start_co, resume
extern  printer
extern my_func, scheduler
extern state


section .data
        align 16
        debug_flag: DB 0
        align 16
        file_pointer: DD 0
        WorldWidth: DD 0
	len_width equ $-WorldWidth
        WorldLength: DD 0
        retVal: DD 0
        countTheRoutins: DD 0
        num_gen: DD 0
        frequency: DD 0
        multiplicand: dd 10 ;for atoi function
        tab db ' '
   	len_tab equ $-tab 
 	Str_newline: db 10  
        deb_msg db 'debug: '
   	len_deb_msg equ $-deb_msg   

section .bss
    reading_with: resb 10000    ; used for reading into state
    descriptor: resd 1;




section .text

%macro print_debug 2
        pushad
        mov eax,4
        mov ebx, 1
        mov ecx,%1
        mov edx,%2
        int 0x80
        popad
%endmacro

main: 
        enter 0, 0
        mov ecx, [ebp+12]; get argv 
        mov edi, [ebp+8]; get argc
        
        cmp edi, 6
        je .no_debug
        add ecx, 4;
        mov byte [debug_flag], 1
        
        .no_debug:
        mov edx, [ecx+4]; take the first argument 
        mov dword [file_pointer], edx

	;get WorldLength
        mov edx, [ecx+8]
	
	;for debug
	mov esi, edx
	cmp [debug_flag], byte 1
	jne .pass_debug1
        print_debug deb_msg, len_deb_msg
	print_debug esi, 1
	.loop_debug1:
	inc esi
	cmp byte[esi],0
	je .print_tab1
	print_debug esi, 1
	jmp .loop_debug1
	.print_tab1:
        print_debug tab, len_tab

	.pass_debug1:
        pushad 
        push edx
        call atoi_in_asm
        add esp,4
        mov dword[WorldLength], eax
        popad        


        ;get WorldWidth
        mov edx, [ecx+12]

	;for debug
	mov esi, edx
	cmp [debug_flag], byte 1
	jne .pass_debug2
	print_debug esi, 1
	.loop_debug2:
	inc esi
	cmp byte[esi],0
	je .print_tab2
	print_debug esi, 1
	jmp .loop_debug2
	.print_tab2:
        print_debug tab, len_tab

	.pass_debug2:
        pushad 
        push edx
        nop
        call atoi_in_asm
        add esp,4
        mov dword[WorldWidth], eax
        popad
        
        
        ;get num of generations (t)
        mov edx, [ecx+16]

	;for debug
	mov esi, edx
	cmp [debug_flag], byte 1
	jne .pass_debug3
	print_debug esi, 1
	.loop_debug3:
	inc esi
	cmp byte[esi],0
	je .print_tab3
	print_debug esi, 1
	jmp .loop_debug3
	.print_tab3:
        print_debug tab, len_tab

	.pass_debug3:
        pushad
        nop
        push edx
        call atoi_in_asm
        add esp,4
        mov dword[num_gen], eax
        popad


        ;get frequency (k)
        mov edx, [ecx+20]
	
	;for debug
	mov esi, edx
	cmp [debug_flag], byte 1
	jne .pass_debug4
	print_debug esi, 1
	.loop_debug4:
	inc esi
	cmp byte[esi],0
	je .print_tab4
	print_debug esi, 1
	jmp .loop_debug4
	.print_tab4:
        print_debug Str_newline, 1

	.pass_debug4:
        pushad 
        push edx
        call atoi_in_asm
        add esp,4
        nop
        mov dword[frequency], eax
        popad
        
        cmp byte[debug_flag],0
        
        je .continue
           ;need to call function print debug here

.continue:


   	  call read_from_file ; reading into state array
     
        mov ebx, 0            ; Coroutine 0 is the scheduler
        mov edi, scheduler    ; edx - addres for certain code
 
        call init_co            ;initialize scheduler 

        inc ebx                ;Coroutine 1 is the printer
        mov edi, printer
        call init_co            ;initialize printer

       mov ecx,dword[countTheRoutins] 
       add ecx,1 ; count schedule and printer.
       add ecx,1
       inc ebx ; get into cells corutines
.cellByCell: ; loop to initilize cells
      cmp ebx ,ecx
      je .cellsAreDone
      mov edi,my_func
      nop
      call init_co 
      inc ebx
      jmp .cellByCell

.cellsAreDone:

        mov ebx, 0             ;
        call start_co           

        mov eax,0
       add eax,1
        mov ebx, 0 
        int 80h
        ret

        
read_from_file:
    push ebp
    mov ebp,esp
    

    pushad
    mov eax,3
    add  eax,2
    mov ebx, dword [file_pointer]
    mov ecx,1
    nop
    sub ecx,1
    mov edx,0777
    int 0x80
    mov dword [descriptor],eax
    popad
    
    
    mov edx, state

.loopOfReading:
    pushad
    mov     eax, 1              
    add eax,2
    mov     ebx, dword [descriptor]    
    mov     ecx, reading_with
    nop
    mov     edx, 2       
    sub edx,1
    int     0x80            
    mov dword[retVal],eax
    popad

     cmp dword[retVal] ,0 
      jle .end_read

        ;for debug
    cmp [debug_flag], byte 1
    jne .skip_debug0
    mov byte esi, reading_with
    cmp byte[reading_with] ,32 ; if space print zero on debug
    jne .no_zero
    mov byte [esi], '0'
    .no_zero:
    print_debug esi, 1

    .skip_debug0:
    cmp byte[reading_with],10
    je .loopOfReading 
    
    cmp byte[reading_with] ,'1' 
    je .toLoop
    cmp byte[reading_with],10
    je .loopOfReading 
    mov byte[edx],'0';
    inc edx
    jmp .loopOfReading
    .toLoop:
    mov byte[edx],'1'
    inc edx
    jmp .loopOfReading

    
.end_read:
 
        pushad
        mov ebx,0
        nop
        mov eax,0
        mov ax,word[WorldLength]; calculate width*length
        mov bx,word[WorldWidth]
        mul bx;
        mov dword[countTheRoutins],eax
        add eax,1
        popad 
        
        mov esp,ebp
        pop ebp
        ret

atoi_in_asm:
        push    ebp
        mov     ebp, esp        ; Entry code - set up ebp and esp
        push ebx
        push ecx
        push edx
        mov eax,0
        mov ebx,0
        mov ecx, dword [ebp+8]  ; Get argument (pointer to string)
        atoi_loop:
        mov edx,0
        cmp byte[ecx],0
        jz  atoi_end
        imul dword[multiplicand]
        mov bl,byte[ecx]
        sub bl,'0'
        add eax,ebx
	inc ecx
        jmp atoi_loop
        atoi_end:
    	pop ebx                 ; Restore registers
        pop ecx
        pop edx
        mov     esp, ebp        ; Function exit code
        pop     ebp
    ret

