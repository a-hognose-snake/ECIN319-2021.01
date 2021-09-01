; Josefina E. Figueroa Ubilla
; Act. Individual 02 - Proyecto Arq. de Computadores
; ITI 2021.01


;Se definen los datos
datos segment
    titulo db "**EL COLGADO*** $"
    pedir_input_teclado db "Palabra: un animal con 6 brazos y 2 patas (Tienes 6 oportunidades). Letra: $"
    nueva_linea db 13, 10, "$"
    mensaje_victoria db "Felicitaciones! Ganaste $"
    mensaje_perdida db "Ja ja! Perdiste $" 
      
    palabra_secreta db "pulpo$"
    palabra_descubierta db 5 dup("?"), "$"
    largo_palabra db 5  
    oportunidades db 6                   
    emparejadas db 0
    errores db 0

ends

;Procedimiento principal
juego segment   
;Se le asigna un espacio a los datos
iniciar_registros:
    mov     ax, datos
    mov     ds, ax

;Comienzo del juego       
loop_principal: 
    ;desplegar nobre del juego por pantalla
    lea     dx, titulo
    call    print 
    ;salto de linea 
    lea     dx, nueva_linea
    call    print
    call    print 
    ;desplegar palabra con letras descubiertas
    lea     dx, palabra_descubierta
    call    print  
    ;salto de linea
    lea     dx, nueva_linea
    call    print    
    call    print
    ;llama verificar estado del juego 
    call    verificar_estado
    ;desplegar mensaje para pedir letra de la palabra
    lea     dx, pedir_input_teclado
    call    print
    ;llama leer input
    call    leer_input  
    ;llama actualizar y desplegar palabra con letras descubiertas 
    call    actualizar
    
    
    ;limpiar pantalla   
    call    limpiar_pantalla 
    ;repetir loop principal    
    loop    loop_principal 
          
;chequea si se ha perdido, ganado o si se puede seguir jugando          
verificar_estado:
    ;Si se ha llegado al tope de oportunidades 
    ;y no se ha encontrado la palabra, perdiste              
    mov     bl, ds:[oportunidades]
    mov     bh, ds:[errores]
    cmp     bl, bh   ;se compara y se salta si se cumple
    ;salta a game_over si te quedaste sin oportunidades
    je      game_over  
    
    ;Si has emparejado todas las letras y no has llegado al tope de oportunidades
    ;ganaste
    mov     bl, ds:[largo_palabra]
    mov     bh, ds:[emparejadas]
    cmp     bl, bh ;se compara y se salta si se cumple
    ; salta a vistoria si has emparejado todas las letras y no has llegado al limite de oportunidades
    je      victoria
    
    ;Si no has ganado, ni perdido, prosigue el juego
    ret          
    
;ve si la letra input existe en la palabra
actualizar:  
    lea     si, palabra_secreta
    lea     di, palabra_descubierta     
    mov     bx, 0
        
    comparar:
    cmp     ds:[si], "$"   ;se compara y se salta si se cumple
    je      letra_correcta
    
    ;ve si la letra esta repetida
    cmp     ds:[di], al    ; se compara y se salta si se cumple
    je      contar_oportunidad
    
    ;ve si la letra coincide con alguna en la palabra   
    cmp     ds:[si], al    ; se compara y se salta si se cumple 
    je      letra_emparejada
                           
    ;cuenta oportunidad
    contar_oportunidad:
    inc     si
    inc     di   
    jmp     comparar    
    ;cuenta oportudinad y al ser letra correcta, se actualiza la palabra incognita          
    letra_emparejada:
    mov     ds:[di], al
    inc     emparejadas
    mov     bx, 1
    jmp     contar_oportunidad             
    ;se actualiza la palabra incognita
    letra_correcta:  
    cmp     bx, 1
    je      retorna_palabra_actualizada
    ;Si no es correcta la letra o se repite, se contbiliza un error
    inc     errores      
    ;retorna palabra actualizada
    retorna_palabra_actualizada:
    ;prosigue el juego
    ret

;define lo que pasa si pierdes
game_over: 
    ;se despliega mensaje del perdedor
    lea     dx, mensaje_perdida
    call    print
    ; se salta a final y se termina el juego
    jmp     final

; define que psa si ganas
victoria: 
    ;se despliega mensaje de ganar
    lea     dx, mensaje_victoria
    call    print
    ;se salta al final y termina el juego
    jmp     final
  
; se define el limpiar pantalla previo a actualizar y seguir el juego
limpiar_pantalla:   
    mov     ah, 0fh
    int     10h   
    
    mov     ah, 0
    int     10h
    
    ret
        
;se define la lectura del teclado y se prosigue con el juego/programa 
leer_input: 
    mov     ah, 1
    int     21h
    
    ret
    
;se define desplegar
print:
    mov     ah, 9
    int     21h
    
    ret

; se define el termino del juego   
final:
    jmp     final         
;termina loop de juego    
juego ends
;termina la iniciacion de registros
end iniciar_registros
