

org  100h        
      
    jmp start
      
; data
    dim equ 200
    melc dw dim dup(0)
    snake dw dim dup(0)
    lung dw 5

    
start:
    mov al, 0
    mov ah, 03h
    int 10h   
    
    mov bl, 0dh; stabilire culoare chenar
    
    
; desenare cap de chenar    
    mov dh, 0; lin = 0 
    mov cx, 1; un singur caracter
    mov al,'+'; stabilire caracter ce se va afisa la pozitia cursorului
    
    mov dl, 0; col = 0  
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h
    
    mov ah, 09h; afisare
    int 10h   
    
    mov dl, 79; col = 79  
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h

    mov ah, 09h; afisare
    int 10h   
    
    mov dl, 1; col = 79  
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h

    mov al,'-'; stabilire caracter ce se va afisa la pozitia cursorului
    mov ah, 09h; afisare
    mov cx, 78; 78 caractere
    int 10h
    
    
; desenare parte inferioara chenar    
    mov dh, 24; lin = 0
    mov cx, 1; un singur caracter
    mov al,'+'; stabilire caracter ce se va afisa la pozitia cursorului

    mov dl, 0; col = 0  
    mov ah, 02h; pozitionare cursor pe linia din DH si coloana din DL
    int 10h
    
    mov ah, 09h; afisare
    int 10h   
    
    mov dl, 79; col = 79  
    mov ah, 02h; pozitionare cursor pe linia din DH si coloana din DL
    int 10h
    
    mov ah, 09h; afisare
    int 10h   
    
    mov dl, 1; col = 1  
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h
    
    mov al,'-'; stabilire caracter ce se va afisa la pozitia cursorului
    mov ah, 09h; afisare
    mov cx, 78; 78 caractere
    int 10h
    
 
  
;desenare margini
    mov al,'|'; stabilire caracter ce se va afisa la pozitia cursorului
    mov cx, 1


    mov dl, 0; col = 0  
    mov dh, 1
    
x1:           
    
    ; pentru primul element al liniei
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h
    
    mov ah, 09h; afisare
    int 10h   

    inc dh
    cmp dh, 24
    jne x1   
    

    mov dl, 79; col = 79  
    mov dh, 1
    
x2:           
    
    ; pentru primul element al liniei
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h
    
    mov ah, 09h; afisare
    int 10h   
    
    inc dh
    cmp dh, 24
    jne x2    
    
    ;beep
    mov al, 7
    int 10h

    
; initializare sarpe
    mov ah, 12
    mov al, 40
    mov di, 0
    ;call depl
    mov cx, melc[di] ; stabilire coordonate pentru cap 
    
x3:
    dec al
    inc di
    mov melc[di], ax; stabilire coordonate pentru cap
    cmp di, 5
    jne x3
   
; desenare sarpe initial
    mov bl, 0ch; stabilire culoare sarpe

    mov dx, melc[0]
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h
    
    mov al, 'O'
    mov ah, 09h; afisare
    mov cx, 1
    int 10h   


ret

depl proc near
    mov cx, melc[0]


depl endp

