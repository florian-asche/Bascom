$regfile "m8def.dat"
$crystal = 12000000
$baud = 9600

Config Portd.7 = Input
Config Portd.6 = Output

Dim Lichtschranke As Integer


Do
 If Pind.7 = 1 Then
   If Lichtschranke = 0 Then
      Portd.6 = 1
      Print "aus"
      Lichtschranke = 1
      Waitms 300
   End If
 Else
   If Lichtschranke = 1 Then
      Portd.6 = 0
      Print "an"
      Lichtschranke = 0
      Waitms 300
   End If
 End If
Loop
End

