'######################################
'#        Serverschrank System        #
'#       (c) by Florian Asche         #
'#              09.03.2011            #
'######################################
'#     Bascom Programm (1Wire+PWM)    #
'######################################

$regfile "m32def.dat"                                     'Dem Programm sagen was für ein Controller verwendet wird

$crystal = 14745600                                         'Taktrate des Controllers einstellen
$baud = 9600                                                'Baudrate der Seriellenschnittstelle Einstellen

Print "Booting System..."

Config Portd.4 = Output                                     'PWM: Den PORTD.4 als Output Konfigurieren/Freischalten
Config Portd.5 = Output                                     'PWM: Den PORTD.4 als Output Konfigurieren/Freischalten
'Config Adc = Single , Prescaler = Auto , Reference = Internal
Dim Adcwert As Word
Dim Adcwert1 As Word
Dim Adcwert2 As Word
Config 1wire = Porta.5                                      'Port für 1wire DS18B20
'Buzzer Alias Porta.7                                        'Port für Buzzer (Sound)
Config Timer1 = Pwm , Pwm = 8 , Compare A Pwm = Clear Up , Compare B Pwm = Clear Up , Prescale = 1       'Konfiguration für PWM
Compare1a = 255                                             'Lüfter abschalten
Compare1b = 255                                             'Lüfter abschalten
Dim Runde As Integer                                        'Rundenzähler: Deklarieren der Variable (Bekanntmachen der Variable)
Dim Zeichen As Word                                         'RS232: Deklarieren der Variable (Bekanntmachen der Variable)
Dim Befehl As String * 50                                   'RS232: Deklarieren der Variable (Bekanntmachen der Variable)
Dim Pwmwert As String * 3                                   'PWM Deklaration
Dim Pwmwert2 As Word                                        'PWM Deklaration
Dim Varcompare1a As Word                                    'PWM Deklaration
Dim Varcompare1b As Word                                    'PWM Deklaration
'Dim Pwm_alt_a As Word                                      'PWM Deklaration
'Dim Pwm_alt_b As Word                                      'PWM Deklaration
Dim Einbefehl As Bit                                        'RS232: Deklarieren der Variable (Bekanntmachen der Variable)

Dim Adcalarmsub As Bit                                      'Alarmsystem schleifenstatus
Dim Adcalarmsub1 As Bit                                     'Alarmsystem schleifenstatus
Dim Adcalarmsub2 As Bit                                     'Alarmsystem schleifenstatus
'Dim Backupsystemstatus As Bit                              'Backupsystem: Deklarieren der Variable (Bekanntmachen der Variable)
'Dim Alarm As Bit                                           'Backupsystem: Deklarieren der Variable (Bekanntmachen der Variable)
'Backupsystemstatus = 1                                     'Backupsystem einschalten
Adcalarmsub = 0
Adcalarmsub1 = 0
Adcalarmsub2 = 0
Einbefehl = 0                                               'RS232 Prüfvariable: Variablen auf 0 Setzten
Befehl = ""                                                 'Befehl = keiner
Runde = 0                                                   'Rundenzähler: Variablen auf 0 Setzten
Pwmwert2 = 0                                                'Standard PWM Wert setzen falls mal kein Wert eingegeben wird
'Dim Emergencytemp As Single                                'Emergency: Deklarieren der Variable (Bekanntmachen der Variable)
'Emergencytemp = 35                                         'Hier wird der Schwellenwert gesetzt ab dem der Microcontroller aus selbstschutz in den Emergency Mode geht.

'1Wire Deklarationen''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim Adresse(8) As Byte                                      '1Wire: Deklarieren der Variable (Bekanntmachen der Variable)
Dim Daten(9) As Byte                                        '1Wire: Deklarieren der Variable (Bekanntmachen der Variable)
Dim I As Integer                                            '1Wire: Deklarieren der Variable (Bekanntmachen der Variable)
Dim Pos As Byte                                             '1Wire: Deklarieren der Variable (Bekanntmachen der Variable)
Dim Grad As Word                                            '1Wire: Deklarieren der Variable (Bekanntmachen der Variable)
Dim Vz As String * 1                                        '1Wire: Deklarieren der Variable (Bekanntmachen der Variable)
Dim Wert As Single                                          '1Wire: Deklarieren der Variable (Bekanntmachen der Variable)
'Dim Wertarray(20) As Single                                '1Wire: Deklarieren der Variable (Bekanntmachen der Variable)
'Dim Idarray(20) As String * 16                             '1Wire: Deklarieren der Variable (Bekanntmachen der Variable)
'Dim Vzarray(20) As String * 1                              '1Wire: Deklarieren der Variable (Bekanntmachen der Variable)
Dim Id As String * 16                                       '1Wire: Deklarieren der Variable (Bekanntmachen der Variable)
Dim Anzahlsensoren As Byte                                  '1Wire: Deklarieren der Variable (Bekanntmachen der Variable)

'DHT11 Sensor Deklarationen'''''''''''''''''''''''''''''''''''''''''''''''''''''
Dhtput Alias Portd.6
Dhtget Alias Pind.6
Dhtioset Alias Ddrd.6
Dim Dht11tmp As Byte
Dim Dhtdhtmybyte As Byte
Dim Dhtwenshi As String * 40
Dim Tmpstr8 As String * 8
Dim Dhtcount As Byte
Dim Dhttemp As Byte
Dim Dhtlufu As Byte
Declare Sub Dht11()

'RS232 Befehle empfangen''''''''''''''''''''''''''''''''''''''''''''''''''''''''
On Urxc Onrxd                                               'Wenn RS232 Interrupt Sub aufrufen
Enable Urxc                                                 'Serial RX complete interrupt Aktivieren
Enable Interrupts                                           'Interrupt Aktivieren

'Startroutinen ausführen''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Sound Buzzer , 400 , 650                                    'BEEP
Print "Prüfe System..."
Compare1a = 0                                               'Lüfter durchstarten
Compare1b = 0                                               'Lüfter durchstarten
'Waitms 4000                                                'Lüfter durchstarten lassen
'Compare1a = 50                                             'Lüfter abschalten
'Compare1b = 50                                             'Lüfter abschalten
Gosub 1wirecheck
Gosub 1wire
'Gosub 1wireausgabe

'Startsound'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Sound Buzzer , 400 , 650                                   'BEEP
'Sound Buzzer , 400 , 250                                   'BEEP
'Waitms 200                                                 '0,2 Sek Wartezeit
'Sound Buzzer , 400 , 250                                   'BEEP

Print "System Status: ALL OK"
Print "Hilfe mit ?"
Print "EOF"

'Programmschleife'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Do                                                          'Starten der Loop Schleife
'Print Einbefehl
'Print Befehl
 If Einbefehl = 1 Then                                      'Prüfen ob RS232 Signal Aktiv
      If Befehl = "alive" Then                              'Wenn RS232 Befehl "alive" ist
            Print "SYSTEM HERE"                             'Ausgabe beenden
            Print "EOF"                                     'Ausgabe beenden
      Elseif Befehl = "1wire" Then                          'Wenn RS232 Befehl "1wire" ist
            Gosub 1wire
            'Gosub 1wireausgabe                              'Sub für 1Wire Ausgabe aufrufen
            Print "EOF"                                     'Ausgabe beenden
      Elseif Befehl = "dht11" Then                          'Wenn RS232 Befehl "1wire" ist
            Gosub Dht11
            Print "EOF"                                     'Ausgabe beenden
      Elseif Befehl = "pwmseta" Then                        'Wenn RS232 Befehl "pwm" ist
            Compare1a = Pwmwert2                            'PWM Setzen
            Varcompare1a = Compare1a
            Print Compare1a                                 'PWM Einstellung Ausgeben
            Print "EOF"                                     'Ausgabe beenden
      Elseif Befehl = "pwmsetb" Then                        'Wenn RS232 Befehl "pwm" ist
            Compare1b = Pwmwert2                            'PWM Setzen
            Varcompare1b = Compare1b
            Print Varcompare1b                              'PWM Einstellung Ausgeben
            Print "EOF"                                     'Ausgabe beenden
      Elseif Befehl = "pwmread" Then                        'Wenn RS232 Befehl "pwmreada" ist
            Varcompare1a = Compare1a
            Varcompare1b = Compare1b
            Print "CHAN A " ; Varcompare1a                  'PWM A Ausgeben
            Print "CHAN B " ; Varcompare1b                  'PWM A Ausgeben
            Print "EOF"                                     'Ausgabe beenden
'      Elseif Befehl = "backupsystem_on" Then                'Wenn RS232 Befehl "backupsystem_on" ist
'            Backupsystemstatus = 1                          'Backupsystem einschalten
'            Print "EOF"                                     'Ausgabe beenden
'      Elseif Befehl = "backupsystem_off" Then               'Wenn RS232 Befehl "backupsystem_off" ist
'            Backupsystemstatus = 0                          'Backupsystem ausschalten
'            Print "EOF"                                     'Ausgabe beenden
'      Elseif Befehl = "backupsystem_status" Then            'Wenn RS232 Befehl "backupsystem_off" ist
'            Print Backupsystemstatus                        'Backupsystem ausschalten
'            Print "EOF"                                     'Ausgabe beenden
'      Elseif Befehl = "backupsystem_alarm" Then             'Wenn RS232 Befehl "backupsystem_off" ist
'            Print Alarm                                     'Backupsystem ausschalten
'            Print "EOF"                                     'Ausgabe beenden
      Elseif Befehl = "portstatus" Then
            Start Adc
            Adcwert = Getadc(4)
            If Adcwert <> 1023 Then
                      'PORT PORTNAME AKTUSTATUS AKTUADC ADCALARMSUB ADCALARMSUB_1 ADCALARMSUB_2
               Print "PORT A1 - 0 " ; Adcwert ; " - " ; Adcalarmsub ; " - " ; Adcalarmsub1 ; " " ; Adcwert1 ; " - " ; Adcalarmsub2 ; " " ; Adcwert2       'KEIN ALARM
            Else
               Print "PORT A1 - 1 " ; Adcwert ; " - " ; Adcalarmsub ; " - " ; Adcalarmsub1 ; " " ; Adcwert1 ; " - " ; Adcalarmsub2 ; " " ; Adcwert2       'ALARM
            End If
            Adcalarmsub = 0
            Adcalarmsub1 = 0
            Adcalarmsub2 = 0
            Print "EOF"
      Elseif Befehl = "?" Then                              'Wenn RS232 Befehl "?" ist
            Print "Hilfsmenü:"                              'Ausgabe: Hilfsmenü
            Print "- alive                 Info, ob das Geraet noch lebt"       'Ausgabe: Hilfsmenü
            Print "- 1wire                 Temperatursensoren Abfrage"       'Ausgabe: Hilfsmenü
            Print "- pwmseta<wert>         Lüftersteuerung 1. Luefter"       'Ausgabe: Hilfsmenü
            Print "- pwmsetb<wert>         Lüftersteuerung 2. Luefter"       'Ausgabe: Hilfsmenü
            Print "- pwmread               Ausgabe der gesetzten Werte der Lüftererung"       'Ausgabe: Hilfsmenü
            Print "- dht11                 DHT11 Sensor"
'            Print "- backupsystem_on       einschalten des Backupsystems"       'Ausgabe: Hilfsmenü
'            Print "- backupsystem_off      ausschalten des Backupsystems"       'Ausgabe: Hilfsmenü
'            Print "- backupsystem_status   Status des Backupsystems"       'Ausgabe: Hilfsmenü
'            Print "- backupsystem_alarm    Zustand des Backupsystems"       'Ausgabe: Hilfsmenü
            Print "- portstatus            ADC/Türstatus des Serverschranks"       'Ausgabe: Hiltsmen
            Print "- ?                     Hilfe"           'Ausgabe: Hilfsmenü
            Print "EOF"                                     'Ausgabe beenden
      Else                                                  'Wenn der Befehl nicht erkannt wurde
            Print "Unbekannter Befehl... (Hilfe mit ?)"     'Fehlermeldung ausgeben
            Print "EOF"                                     'Ausgabe beenden
      End If
      Einbefehl = 0                                         'Befehlseingabeprüfung zurücksetzen
      Befehl = ""                                           'Variable für Befehl zurücksetzen
      Pwmwert = ""                                          'Variable für Pwmwert zurücksetzen
      Pwmwert2 = 0                                          'Variable für Pwmwert zurücksetzen
      Enable Urxc                                           'Interrupt für RS232 wieder Aktivieren
 End If
 Incr Runde                                                 'Variable Runde um 1 erhöhen
 If Einbefehl <> 1 Then
    If Runde => 1200 Then                                   'Wenn 1200 Runden erreicht sind
         'If Einbefehl <> 1 Then
            'Print "==========================================="
            'Print "Runde: " ; Runde
         'End If
'         Gosub 1wire                                        'Sub für Messung aufrufen
         'Gosub 1wireausgabe

'         If Backupsystemstatus = 1 Then
'            Gosub Backupsystem                              'Sub für Temperaturprüfung aufrufen
            'Print "CHECK"
           'Print "EOF"
'         End If

'         Runde = 0
'         Waitms 400
      Gosub Adccheck
   End If
 End If
Loop                                                        'Ende der Loop Schleife
End

'1Wire Ausgabe''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'1wireausgabe:
' Print "ausgabe start"
' Print
' Print
' For I = 1 To Anzahlsensoren
'      Print Idarray(i) ; " Temperatur " ; I ; ": " ; Vzarray(i) ; Fusing(wertarray(i) , "###.##") ; " Grad"       'Daten Ausgeben
' Next I
'Return

'Backup System Falls Server Down                             ''''''''''''''''''''''''''''''''''''''''''''''''
'Backupsystem:
' If Backupsystemstatus = 1 Then
'    If Wertarray(1) => Emergencytemp Then
'         If Alarm = 0 Then
'         Pwm_alt_a = Compare1a
'         Pwm_alt_b = Compare1b
'         End If
'         Compare1a = 0
'         Compare1b = 0
'         Alarm = 1
'         Print "SYSTEM WARNING: Temperatur liegt bei " ; Wertarray(1) ; " und somit über " ; Emergencytemp ; " Grad!"
         'Sound Buzzer , 400 , 450                           'BEEP
         'Sound Buzzer , 400 , 750                           'BEEP
         'Waitms 50                                          'Wartezeit
         'Sound Buzzer , 400 , 750                           'BEEP
         'Waitms 50                                          'Wartezeit
         'Sound Buzzer , 400 , 750                           'BEEP
'    Else
'         If Alarm = 1 Then
'            Alarm = 0
'            Compare1a = Pwm_alt_a
'            Compare1b = Pwm_alt_b
'            Print "END OF SYSTEM WARNING: SYSTEM GOING BACK TO NORMAL"
'    End If
'    End If
' End If
'Return

Adccheck:
   Waitms 400
   Start Adc
   Adcwert1 = Getadc(4)

   If Adcwert1 <> 1023 Then
      'DO NOTHING
   Else
      Adcalarmsub1 = 1
   End If

   Waitms 2000
   Start Adc
   Adcwert2 = Getadc(4)

   If Adcwert2 <> 1023 Then
      'DO NOTHING
   Else
      Adcalarmsub2 = 1
   End If

   If Adcalarmsub1 = 1 Then
      If Adcalarmsub2 = 1 Then
         Adcalarmsub = 1
      End If
   End If
Return


'1Wire Prüfung''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
1wirecheck:
Anzahlsensoren = 0
 Anzahlsensoren = 1wirecount()                              'Anzahl an Sensoren in Variable schreiben
 If Anzahlsensoren > 0 Then                                 'Wenn Sensoren gefunden wurden dann
      Print "Anzahl Sensoren: " ; Anzahlsensoren            'Anzahl der gefundenen Sensoren ausgeben
      Print "EOF"
 Else                                                       'Wenn keine Sensoren gefunden wurden dann
      Print "SYSTEM ERROR: Kein Sensor gefunden!"           'Fehlermeldung ausgeben
      Print "EOF"
     ' Sound Buzzer , 400 , 450                              'BEEP
     ' Sound Buzzer , 400 , 750                              'BEEP
     ' Waitms 50                                             'Wartezeit
     ' Sound Buzzer , 400 , 750                              'BEEP
     ' Waitms 50                                             'Wartezeit
     ' Sound Buzzer , 400 , 750                              'BEEP
      Waitms 800                                            'Wartezeit
      Goto 1wirecheck                                       'Prüfung wieder von vorne anfangen
 End If
Return


Sub Dht11()
   Set Dhtioset
   Set Dhtput

   Dhtcount = 0
   Dhtwenshi = ""
   Set Dhtioset
   Reset Dhtput
   Waitms 20

   Set Dhtput
   Waitus 40
   Reset Dhtioset
   Waitus 40
   If Dhtget = 1 Then
      Dhtlufu = 255
      Print "Error"
      Exit Sub
   End If

   Waitus 80
   If Dhtget = 0 Then
      Dhtlufu = 255
      Print "Error"
      Exit Sub
   End If

   While Dhtget = 1 : Wend

   Do
      While Dhtget = 0 : Wend

      Waitus 30
      If Dhtget = 1 Then
         Dhtwenshi = Dhtwenshi + "1"
         While Dhtget = 1 : Wend
         Else
         Dhtwenshi = Dhtwenshi + "0"
      End If
      Incr Dhtcount
   Loop Until Dhtcount = 40

   Set Dhtioset
   Set Dhtput

   Tmpstr8 = Left(dhtwenshi , 8)
   Dhtlufu = Binval(tmpstr8)

   Tmpstr8 = Mid(dhtwenshi , 17 , 8)
   Dhttemp = Binval(tmpstr8)

   Tmpstr8 = Right(dhtwenshi , 8)
   dht11Tmp = Binval(tmpstr8)

   Dhtdhtmybyte = Dhttemp + Dhtlufu
   If Dhtdhtmybyte <> Dht11tmp Then
      Dhtlufu = 255
      Print "Error"
   End If

   Print "Temperatur: " ; Dhttemp ; " C und Luftfeuchtigkeit: " ; Dhtlufu ; " %"
End Sub

'Temperaturausgabe''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
1wire:
'Print "1wire read start"
 Id = ""
 Grad = 0
 Vz = ""
 Wert = 0
 1wreset                                                    'Initialisierung des Bausteins
 1wwrite &HCC                                               'Überspringe Rombefehl (Skip Rom)
 1wwrite &H44                                               'Messung durchführen und im Speicher/Register ablegen (Convert T)
 Waitms 800                                                 'Auf Messung warten
 Pos = 0                                                    'Variable auf 0 Setzen damit er bei 0 anfängt zu zählen
 Anzahlsensoren = 0
 Anzahlsensoren = 1wirecount()                              'Anzahl Sensoren ermitteln

' Print "1wire after 1wirecount"

 'If Einbefehl <> 1 Then
   'Print "Sensoren: " ; Anzahlsensoren
 'End If
 While Pos < Anzahlsensoren                                 'Für jeden gefundenen Sensor einen Ablauf der nachfolgenden Befehle
      If Pos = 0 Then                                       'Prüfen ob der Durchlauf der erste ist
            Adresse(1) = 1wsearchfirst()                    'Erste ID des 1wire Bus in Variable(array) einlesen
      Else                                                  'Prüfen ob der Durchlauf nicht der erste ist
            Adresse(1) = 1wsearchnext()                     'Nächste ID des 1wire Bus in Variable(array) einlesen
      End If
      Incr Pos                                              'Positionszähler einen höher setzen
      Id = ""
      For I = 1 To 8                                        'Schleife für die Adresse
           ' If Einbefehl <> 1 Then
               Print Hex(adresse(i)) ;                      'Adresse ausgeben 28 DC 9F 06 02 00 00 39
            'End If
            'Id = Id + Hex(adresse(i)) ;
      Next I
      'Print
      1wreset                                               'Initialisierung Des Bausteins
      1wwrite &H55                                          'Sensor auswählen (Match Rom command)
      1wwrite Adresse(1) , 8                                'Adresse zum auswählen senden
      1wwrite &HBE                                          'Inhalt(Temperaturwert) aus dem Register auslesen
      For I = 1 To 9                                        'Schleife Für den Temperaturwert
            Daten(i) = 1wread()                             'Daten in ein Array schreiben
      Next I
      1wreset                                               'Initialisierung des Bausteins
 If Daten(2) >= 248 Then                                    'Prüfen ob Temperatur im Negativ Bereich liegt
 Vz = "-"                                                   'Vorzeichen auf "-" Setzen
 Daten(1) = &HFF - Daten(1)                                 '***
 Daten(2) = &HFF - Daten(2)                                 '***
 Else                                                       'Wenn das Vorzeichen nicht - ist dann ist es +
 Vz = "+"                                                   'Vorzeichen auf "+" Setzen
 End If
 Grad = Daten(2)                                            '***
 Shift Grad , Left , 8                                      '***
 Grad = Grad + Daten(1)                                     '***
 Wert = Grad * 0.0630                                       'Wert mit Samplefaktor multiplizieren
 'If Einbefehl <> 1 Then
 Print " Temperatur " ; Pos ; ": " ; Vz ; Fusing(wert , "###.##") ; " Grad"       'Daten Ausgeben
 'End If
 'Wertarray(pos) = Wert
 'Vzarray(pos) = Vz
 'Idarray(pos) = Id
 1wreset                                                    'Initialisierung Des Bausteins

 Wend                                                       'Ende der While Schleife
 'DALLAS DS18B20 ROM and scratchpad commands:
 ' 1wwrite....
 ''' &H 33 read rom - single sensor
 ''' &H 55 match rom, followed by 64 bits
 ''' &H CC skip rom
 ''' &H EC alarm search - ongoining alarm >TH <TL
 ''' &H BE read scratchpad
 ''' &H 44 convert T
Return

'RS232 UART ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Onrxd:
 Zeichen = Udr                                              'Byte aus der UART auslesen
 If Zeichen <> 13 Then                                      'Wenn Zeichen = CR (Enter)
      If Zeichen <> 10 Then                                 'Wenn Zeichen = LF
            If Befehl = "pwmseta" Then
               'Print "PWM ERKANNT"
               'Print Befehl ; "-" ; Pwmwert
               Pwmwert = Pwmwert + Chr(zeichen)
               Pwmwert2 = Val(pwmwert)
            Elseif Befehl = "pwmsetb" Then
               'Print "PWM ERKANNT"
               'Print Befehl ; "-" ; Pwmwert
               Pwmwert = Pwmwert + Chr(zeichen)
               Pwmwert2 = Val(pwmwert)
            Else
               Befehl = Befehl + Chr(zeichen)               'Dann Befehl = bisher gesammelten Zeichen + neues Zeichen
             '  Print Befehl
            End If
      End If                                                'Ende
 Elseif Zeichen = 13 Then                                   'Wenn nur Zeichen = CR (Enter)
      'Print Befehl ; "-" ; Pwmwert
      Einbefehl = 1                                         'Variable Eingabeprüfung auf ein Setzen
      Disable Urxc                                          'Keine weiteren Zeichen Lesen
 End If
Return