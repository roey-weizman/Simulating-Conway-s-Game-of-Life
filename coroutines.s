 global init_co, start_co, end_co, resume,cors,state
        global my_func
    
        extern WorldWidth  
        extern Cell
        extern countTheRoutins
        extern frequency,num_gen


maxcors:        equ 10000+2            
stacksz:        equ 16*1024        


section .bss

state: resb 10000

stacks: resb maxcors * stacksz     
temp1: resd 1
cors:   resd maxcors 
temp2: resd 1              
curr:   resd 1                     
temp3: resd 1
origsp: resd 1                     
temp4: resd 1
tmp:    resd 1   



section .data
        align 16
        temp5: DD 0
section .text

      

my_func:
   push ebp
   mov ebp,esp
   pushad
   push dword[ebp+4*3] 
   push dword[ebp+4*2]
   call Cell
   add esp,4*2
   nop
   mov dword[tmp],eax
   popad
   mov eax,dword[tmp]

level_1:
    mov ecx,ebx   
    sub ebx,1    
    sub ebx,1
    nop
    xor edi,edi
    mov edi,ebx    
    xor ebx,ebx    
    call resume
level_2:
    mov byte[state+edi],al   
    xor ebx,ebx   
    call resume
    mov ebx,ecx   
    nop
    pop ebp
    jmp my_func



init_co:
        push eax                
        push edi
        xor edi,edi
        mov eax,stacksz
        imul ebx			    
        pop edi
        add eax, stacks + stacksz   
        mov [cors + ebx*4], eax    
        pop eax                    
        mov [tmp], esp             
        mov esp, [cors + ebx*4]    

finishing_the_init:
            cmp ebx,0  
            jne this_is_not_the_schedueler
            
            push dword [frequency]
            push dword [num_gen]
            push 42     
this_is_not_the_schedueler:
        nop
        cmp ebx,2
        jl not_a_regular_co_routine
         
        
       mov dword[temp2],ebx  
       mov dword[temp1],eax  
       mov dword[temp4],edi  
       mov dword[temp3],ecx  
        
        sub ebx,1
        sub ebx,1
        mov ecx ,dword[WorldWidth]
        mov eax , ebx    
        
        
        
        div cl       
        mov ecx,0
        
        mov cl,ah
        mov ebx,0
        mov bl,al
       
        push ecx      
        push ebx      
        push 42    
        
        mov edi,dword[temp4]  
        
        mov eax,dword[temp1]  
        mov ecx,dword[temp3]  
        mov ebx,dword[temp2]  

not_a_regular_co_routine:
        push edi                
        pushf                     
        pusha                     
        mov [cors + ebx*4], esp    

        mov esp, [tmp]             
        ret                        

        
start_co:
        pusha                      
        mov [origsp], esp          
        mov [curr], ebx            
        jmp resume.cont            

     
end_co:
        mov esp, [origsp]          
        popa                       
        ret                       

      
resume:                            
        pushf                     
        pusha                      
        xchg ebx, [curr]           
        mov [cors + ebx*4], esp    
        mov ebx, [curr]            
.cont:
        mov esp, [cors + ebx*4]    
        popa                       
        popf                       
        ret                        