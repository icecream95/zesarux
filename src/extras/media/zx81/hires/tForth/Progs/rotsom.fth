\ ----------------------------------------------------
\ Transcri��o para o zx81 Toddy Forth das rotinas
\ apresentadas na revista Micro Sistemas N� 49, no
\ artigo de Ivan Camilo da Cruz: Som em Forth.
\ ----------------------------------------------------

: TASK ;

HEX
CODE SLOW  ( -- )             ( set the SLOW mode )
  D9 C,           \ exx
  CD C, F2B ,     \ call $f2b  ; SLOW
  D9 C,           \ exx
  NEXT            \ jp NEXT

CODE FAST  ( -- )             ( set the FAST mode )
  CD C, F23 ,     \ call $f23  ; FAST
  NEXT            \ jp NEXT

\ A palavra ROTSOM e derivadas devem ser executadas
\ obrigatoriamente em modo FAST (ver palavra ZORRA)

CODE ROTSOM  ( dur2 dur1 -- )
  E1 C,           \ POP HL      ; Carrega o 2OS em HL
  D3 C, FF C,     \ OUT (FF),A  ; VSYNC off
  41 C,           \ LD B,C      ; Dura��o da primeira metade
  10 C, FE C,     \ DJNZ -2
  DB C, FE C,     \ IN A,(FE)   ; VSYNC on
  45 C,           \ LD B,L      ; Dura��o da segunda metade
  10 C, FE C,     \ DJNZ -2
  C1 C,           \ POP BC      ; Atualiza o TOS
  NEXT            \ jp NEXT


: BEEP-AGUDO  ( dur -- )
  1
  DO
    1 DUP ROTSOM
  LOOP
;

: BEEP-MEDIO  ( dur -- )
  1
  DO
    20 DUP ROTSOM
  LOOP
;
: BEEP-GRAVE  ( dur -- )
  1
  DO
    FF DUP ROTSOM
  LOOP
;
: BEEP-VARIAVEL  ( freq dur -- )
  0
  DO
    DUP DUP ROTSOM
  LOOP
  DROP
;
: RAIO<  ( freq< freq> -- )
  SWAP
  DO I 1 BEEP-VARIAVEL
  LOOP
;
: RAIO>  ( freq> freq< -- )
  2DUP + ROT ROT
  DO
    DUP I - 1 BEEP-VARIAVEL
  LOOP
  DROP
;
: SIRENE  ( freq> freq< repeat -- )
  0
  DO
    2DUP RAIO>
    2DUP SWAP RAIO<
  LOOP
  2DROP
; DECIMAL
: ZORRA
  FAST
  200 50 2 SIRENE
  0 255 10 220 55 190 RAIO< RAIO< RAIO<
  190 55 220 1 255 0 RAIO> RAIO> RAIO>
  230 25 3 SIRENE
  180 70 70 180 180 70 70 180 RAIO< RAIO> RAIO< RAIO>
  200 0 170 0 140 0 110 0 RAIO> RAIO> RAIO> RAIO>
  80 0 50 0 20 0 RAIO> RAIO> RAIO>
  0 220 0 190 0 160 0 130 RAIO< RAIO< RAIO< RAIO<
  0 100 0 70 0 40 0 10 RAIO< RAIO< RAIO< RAIO<
  650 0 3 SIRENE
  SLOW
;
 