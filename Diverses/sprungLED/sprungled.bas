$regfile = "m8def.dat"
$crystal = 12000000

Config Portd = Output
Dim Wert As Integer
Dim Wert2 As Integer
Dim I As Integer

Do

   Wert = 1                                                 'Anfangswert bzw nach jeden loop wert(2) zurücksetzen
   Wert2 = 128

   For I = 0 To 6                                           'Bei 7 werden die aueßeren leds doppelt hintereinander angesteuert
      Portd = Wert
      Wert = Wert * 2                                       'Wert verdoppeln für nächste led
      Waitms 200
      Portd = Wert2                                         'andere seite des ledblocks ansteuern
      Wert2 = Wert2 / 2                                     'Wert halbieren für vorherige led
      Waitms 200
   Next
Loop