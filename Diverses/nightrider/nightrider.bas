$regfile = "m8def.dat"
$crystal = 12000000
Dim Wert As Integer
Dim Wert2 As Integer
Dim Aus As Integer
Dim I As Integer

Config Portd = Output
Wert = 1
Aus = 1

Do
   For I = 1 To 8
      Wert = Wert * 2
      Wert2 = Wert / 2
      Aus = Wert + Wert2
      Portd = Aus
      Waitms 150
   Next
   For I = 1 To 8
      Wert = Wert / 2
      Wert2 = Wert * 2
      Aus = Wert + Wert2
      Portd = Aus
      Waitms 150
   Next
   Portd = 1
   Waitms 150
   Aus = 1
Loop