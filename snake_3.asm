

org  100h        
      
    jmp start
      
; data
    melc dw dim dup(0)
    dim equ 30
    lung dw ?
    efectiv dw ?  
    incr equ 3
    
    
start:       
    ;initializari variabile
    mov bp, 7 ; lungimea initiala
    mov si, 7; dimensiunea efectiva a sarpelui 
    
    
    mov al, 0
    mov ah, 03h
    int 10h   
    
; initializare sarpe
    mov ah, 12
    mov al, 40
    mov di, 0
    ;mov bh
    ;call depl
    mov melc[di], ax ; stabilire coordonate pentru cap 
    
x3:
    dec al
    inc di
    push ax
    mov ax, 2
    mul di
    mov bx, ax
    pop ax
    mov melc[bx], ax; stabilire coordonate pentru restul corpului
    cmp di, bp
    jne x3
   
; desenare sarpe initial
   
    mov cx, 1
    
    ;desenare cap
    mov dx, melc[0]
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h
    
    mov al, 'O'
    mov bl, 0bh; stabilire culoare sarpe
    mov ah, 09h; afisare
    int 10h      
    
    ; desenare corp
    mov di, 1
    mov al, '*'        
x4:
    push ax  
    push bx
    mov ax, 2
    mul di
    mov bx, ax
    mov dx, melc[bx]
    pop bx
    pop ax
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h
    
    mov ah, 09h; afisare
    int 10h 
    inc di   
    ;inc di
    cmp di, bp
    jne x4          
    
    mov es, dx ; salvare dx in es
    call genereaza ;genereaza mancarea si salveaza in ds coloana unde se gaseste mancarea
   
    ; afisare mancare
    mov cx, 1
    mov bl, 0eh
    
    mov dx, es
    mov dl, al
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h
    
    mov al, '#'
    mov ah, 09h; afisare
    int 10h
          
   
    
    
    
; deplasare

x5:
    cmp si, bp 
    jg no_sterge
    
    ; stergere coada
    mov ax, bp   ; scriem lungimea in ax
    dec ax; obtinem indicele
    push bx; salvam bx
    mov bx, 2
    mul bx; inmultim ax cu 2 pentru a obtine octetul  
    mov bx, ax; punem rezultatul in bx      
    mov ss,ax ;salvare rezultat in es
    mov dx, melc[bx]; obtinem din memorie localizarea cozii
    pop bx; refacem bx
    
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h
    
    mov ah, 09h; afisare
    mov al, ' ' 
    mov cx, 1
    int 10h
    
    dec si
    
    no_sterge:
    inc si
    
   
    ; mutare sarpe
    mov bx, ss
    x6:
        mov di, bx
        dec bx
        dec bx
        mov dx, melc[bx]
        mov melc[di],dx
        ;mov cx, bx
        cmp bx, 0
        jne x6
   
        inc dl
        mov cx,ds
        cmp cl, dl
        jne no_length_change
        
            ;schimbare lungime sarpe
            mov cx, lung
            mov ax, incr
            add ax, cx
            mov lung, ax
        
        
        no_length_change:
        cmp dl, 79
        jne cont
    mov dl,0
    
cont:
    mov melc[bx],dx
   
    ;desenam * la cap+1 shi O la cap
   
    mov cx, 1
    mov bl, 0bh
    
    mov dx, melc[2]
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus 
    int 10h
    
    mov al, '*'
    mov ah, 09h; afisare
    int 10h      
    
    mov dx, melc[0]
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h
    
    mov al, 'O' 
    mov ah, 09h; afisare
    int 10h      
    
   
   
   
    
    
   jmp x5



ret

genereaza proc near
    
    mov ah, 2ch ; citeste ceasul
    int 21h
                                
    ; in CH - ore
    ; CL - minute
    ; DH - secunde                                
    
    mov al, dh
    cmp cl, dh
    jb m1
        mov bl, dh
        mov al, cl
        sub al, bl
    
    m1:    
    mov dl, al
    mov dh, 0
    mov ds, dx 

genereaza endp

