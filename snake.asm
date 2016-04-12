  
.model tiny

org  100h        
      
    jmp start
      
; data
    melc    dw  dim     dup(0)
    dim     equ 30
    lung    dw  ?
    efectiv dw  ?  
    incr    equ 3
    food    dw  ?
    st      equ 4bh
    dr      equ 4dh
    sus     equ 48h
    jos     equ 50h
    dir     db  dr  
    message db " *********0  Bine ai venit, introdu initiala jucatorului: $"

; in bp vom salva lungimea totala a sarpelui
; in si avem lungimea afisata    
    
   
start:
;afisare mesaj de inceput pentru utilizator
   
    mov ax, seg message
    mov ds, ax
    mov dx, offset message
    mov ah, 9h
    int 21h 
       
      
        
    mov ah, 1h
    int 21h
     
    ;initializari variabile
    mov bp, 7 ; lungimea initiala
    mov si, 7; dimensiunea efectiva a sarpelui 
    
    
    ;initializare ecran
    mov al, 0
    mov ah, 03h
    int 10h  
    
    call chenar
    
    call init_melc
    
    call desenare_sarpe  
    
    mov ss, dx ; salvare in ss a indicelui corespunzator ultimului element al sarpelui     
    
    call genereaza ;genereaza mancarea si salveaza in food pozitia acesteia
    
    call afis_food
   

    
; deplasare

x5:

    ; citim tasta apasata (daca exista)

    mov     ah, 01h ; citire stare tastatura
    int     16h
    jz      no_tasta

    mov     ah, 00h ; daca a fost apasata o tasta, vedem care este aceea (in AL)
    int     16h

    cmp     al, 1bh    ; esc - key?
    je      end;

    ;mov     dir, ah ; copiem codul in dir
    call update_dir
    
    no_tasta:
    
    cmp bp, si 
    jg no_sterge
    
    ; stergere coada
    mov ax, bp   ; scriem lungimea in ax
    dec ax; obtinem indicele
    push bx; salvam bx
    mov bx, 2
    mul bx; inmultim ax cu 2 pentru a obtine octetul  
    mov bx, ax; punem rezultatul in bx      
    mov ss,ax ;salvare rezultat in ss
    mov dx, melc[bx]; obtinem din memorie localizarea cozii
    pop bx; refacem bx
    
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h
    
    mov ah, 09h; afisare
    mov al, ' '
    mov bl, 00h 
    mov cx, 1
    int 10h
    
    dec si
    
    no_sterge:
    inc si
    
   
    ; mutare sarpe
    mov bx, ss; in SS avem indicele cozii
    x6:
        mov di, bx
        dec bx
        dec bx
        mov dx, melc[bx]
        mov melc[di],dx
        cmp bx, 0
        jne x6
        
        ; calcul pozitie noua a capului
        cmp dir, st
            je move_st
        cmp dir, dr
            je move_dr
        cmp dir, sus
            je move_sus
        cmp dir, jos
            je move_jos  
         
    ;miscare sarpe stanga		 
        move_st:
            dec dl
            cmp dl, 1
            jb end           
            jmp cont
    ;miscare sarpe dreapta	       
        move_dr:
            inc dl
            cmp dl, 78
            ja end
            jmp cont
	;miscare sarpe in jos	
        move_jos:
            inc dh
            cmp dh, 23
            ja end
            jmp cont
	;miscare sarpe in sus	
        move_sus:
            dec dh
            cmp dh, 1
            jb end
         
            

        cont:
            mov melc[bx],dx    
            
            
        ;no_length_change:
        cmp dl, 79
        jne cont_1
    mov dl,0
    
cont_1:
    mov melc[bx],dx; salvam pozitia capului
   
    ;desenam * la cap+1 si O la cap
   
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
    
    push dx ; in dx avem pozitia capului. o salvam deoarece in check self eat se modifica
    call check_self_eat ; pune in AX 0 daca se mananca  
    pop dx ; refacem dx astfel incat sa se regaseasca acolo capul
    cmp ax, 0
    je end
    
    mov ax, food
    cmp ax, dx
    jne cont1
        add bp, incr ; crestere lungime sarpe
        
        mov al, 07h
        mov ah, 09h
        mov cx, 1
        int 10h
        
    
    ; apelam procedura de generare a mancarii   
        call genereaza
    ; apelam procedura de afisare a mancarii   
        call afis_food
   
   
    cont1:
    mov bx, bp
    dec bx
    mov ax, 2
    mul bx 
    mov ss, ax
    
   
   jmp x5   
   
   end:
       mov al, 07h
       mov ah, 09h; afisare
       mov cx, 3
       int 10h
 


ret      
         

;procedura de verificare a modificarii directiei
;in ah avem codul citit
update_dir proc near
    cmp dir, sus
    je update_sus
    cmp dir, jos
    je update_jos
    cmp dir, st
    je update_st
    cmp dir, dr
    je update_dr
                
    update_sus:
    cmp ah, jos
    je no_update_dir
    jmp update_d               
    
    update_jos:
    cmp ah, sus
    je no_update_dir
    jmp update_d               
    
    update_st:
    cmp ah, dr
    je no_update_dir
    jmp update_d               
    
    update_dr:
    cmp ah, st
    je no_update_dir
    jmp update_d               
    
    
    update_d:
    
    mov dir, ah
                          
    no_update_dir:
                           
    ret
update_dir endp   
         

; verificare daca sarpele isi mananca corpul
; in dx avem pozitia capului
check_self_eat proc near
    push di
    mov di, 1 
    sc1:
    mov ax, 2
    mul di 
    mov bx, ax
    mov cx, melc[bx]
    cmp cx, melc[0]
    je eat:        
    inc di
    cmp di, si
    jbe sc1
    mov ax, 1
    jmp check_end    
           
    eat:
    mov ax, 0 
    
    check_end:
    pop di
    ret
    
check_self_eat endp
       

;generarea in ds urmatoarei pozitii a mancarii
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
	inc al
    mov dl, al
    m2:
	inc dh
    cmp dh,23
    jb m3
    sub dh,23
    jmp m2
    m3:
    mov food, dx
    
    ret 

genereaza endp

; initializare pozitie melc
init_melc proc near
    
    ; initializare sarpe
    mov ah, 12
    mov al, 10
    mov di, 0
    ;mov bh
    ;call depl
    mov melc[di], ax ; stabilire coordonate pentru cap 
    
x3:
    dec al ; pentru restul inelelor, pozitia pe axa Ox e cu unu mai mica
    inc di ; crestem indicele inelului
    push ax ; salvam continutul din AX
    mov ax, 2 ; calculam pozitia inelului in vector
    mul di
    mov bx, ax
    pop ax ; refacem AX
    mov melc[bx], ax; stabilire coordonate pentru restul corpului
    cmp di, bp ; daca am calculat coordonatele pentru ultimul inel, ne oprim
    jne x3 ; altfel reluam pentru restul inelelor
    
    ret
init_melc endp    
     
     
desenare_sarpe proc near
    
    ; desenare sarpe initial
    ; in procedura se intra cu numarul de elemente salvat in BP
    ; la iesire in DX se gaseste pozitia cozii
   
    mov cx, 1 ; o singura litera de afisat pe ecran
    
    ;desenare cap
    mov dx, melc[0] ; preluam din melc coordonatele capului
    mov ah, 02h; pozitionare cursor pe linia si coloana din DX
    int 10h
    
    mov al, 'O' ; litera corespunzatoare capului
    mov bl, 0bh; stabilire culoare sarpe
    mov ah, 09h; afisare
    int 10h      
    
    ; desenare corp
    mov di, 1 ; in DI retinem indicele inelului
    mov al, '*' ; litera ce se va afisa pentru inel        
x4:
    push ax ; salvam continutul din AX  
    push bx ; si pe cel din BX
    mov ax, 2 ; inmultim pe DI cu 2 si retinem in AX rezultatul
    mul di
    mov bx, ax ; transferam in BX valoarea calculata, folosita pentru pozitionarea in vectorul de coordonate
    mov dx, melc[bx] ; preluam pozitia curenta
    pop bx ; refacem BX
    pop ax ; refacem AX
    mov ah, 02h; pozitionare cursor pe linia si coloana date de DX
    int 10h
    
    mov ah, 09h ; afisare litera
    int 10h     
    
    inc di ; crestere indice   
    
    cmp di, bp
    jne x4
    
    
    ret
desenare_sarpe endp    

afis_food proc near
    
    ; afisare mancare
    
    mov dx, food
    mov ah, 02h; pozitionare cursor pe linia si coloana de mai sus
    int 10h
    
    mov al, '#'
    mov ah, 09h; afisare
    mov bl, 0eh
    mov cx, 1
    int 10h
          
    ret
afis_food endp           

chenar proc near
    
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
chenar endp

