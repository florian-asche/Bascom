$regfile = "m8def.dat"
$crystal = 12000000
Dim Wert As Integer

Config Portd = Output

Do
   Wert = Wert + 1
   If Wert = 256 Then
      Wert = 0
   End If
   Portd = Wert
   Waitms 100

Loop
