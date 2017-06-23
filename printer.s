
extern WorldLength
extern resume
global printer
extern WorldWidth
extern state


section .data
    align 16
    new_line: DD 0
    index: DD 0
    in_line: DD 0
    Str_newline: db 10

section .text

printer:
        mov dword esi, state
        mov ebx, dword 0
        mov ecx, dword 0
        
        .printer_loop:
        
        cmp ebx, dword[WorldLength]
        je .finish_printing 
        
        .inline:
        cmp ecx, dword [WorldWidth]
        jge .next_line
        
        pushad
        mov eax,4
        mov ebx, 1
        mov ecx,esi
        mov edx,1
        int 0x80
        popad
        
        inc esi
        add ecx, 1
        jmp .printer_loop
        
        ;print new line
        .next_line:
        pushad
        mov eax,4
        mov ebx, 1
        mov ecx, Str_newline
        mov edx,1
        int 0x80
        popad
        
        mov dword ecx, 0
        add ebx, 1
        jmp .printer_loop
        
        
        .finish_printing:
        mov ebx,0
        call resume             ; resume scheduler
        
        jmp printer
