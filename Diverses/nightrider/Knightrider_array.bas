$regfile = "m8def.dat"
$crystal = 12000000

Config Portd = Output

Dim Ausgabe(6) As Byte
Dim I As Integer

Ausgabe(1) = 24
Ausgabe(2) = 36
Ausgabe(3) = 66
Ausgabe(4) = 129
Ausgabe(5) = 66
Ausgabe(6) = 36

Do
   For I = 1 To 6
      Portd = Ausgabe(i)
      Waitms 100
   Next
Loop
End