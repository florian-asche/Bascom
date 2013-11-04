$regfile = "m8def.dat"
$crystal = 12000000
Dim Wert As Integer
Dim Wert2 As Integer
Dim Temp As Integer

Config Portd = Output
Wert = 16
Wert2 = 8

Do
   Wert = Wert / 2
   Wert2 = Wert2 * 2
   Waitms 150
   Temp = Wert + Wert2
   Portd = Temp
   If Wert = 1 Then
      Wert = 16
   End If
   If Wert2 = 128 Then
      Wert2 = 8
   End If
Loop