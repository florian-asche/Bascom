$asm
; (c) by Rosemann
; (c)
;------------------------------------------------------
; Initialisierungen
;------------------------------------------------------
LDI R24, 0 ; Wert "0" in das allgemeine Register R24
MOV R0, R24 ; Wert in das Register R0 verschieben
LDI R24, 5 ; Additionswert in das allgemeine Register R24
MOV R1, R24 ; Wert in das Register R1 verschieben
LDI R24, 3 ; Additionswert in das allgemeine Register R24
MOV R2, R24 ; Wert in das Register R2 verschieben
LDI R24, 255 ; Wert "255" = FF in das allgemeine Register R24
Out Ddrd , R24 ; Port D Auf Output Stellen
;------------------------------------------------------
; Additionsprogramm
;------------------------------------------------------
Hauptschleife:
rjmp vier ; Springe zur Marke "vier"
Zwei:
DEC R1 ; Inhalt des Registers R1 um eins erhöhen
DEC R2 ; Inhalt des Registers R2 um eins erniedrigen
Vier:
Cpse R2 , R0 ; Wenn R2 gleich R0, einen Befehl überspringen
rjmp zwei
Out Portd , R1 ; Springe Zur Marke "zwei"
rjmp Hauptschleife ; Springe Zur Marke "Hauptschleife"
$end Asm