#fasm#

org  100h        

    snake dw 100 dup(0)

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
    
      

    

ret



