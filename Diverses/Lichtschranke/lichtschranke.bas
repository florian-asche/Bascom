$regfile "m8def.dat"
$crystal = 12000000
$baud = 9600

Config Portd.7 = Input
Config Portd.6 = Output

Do

 If Pind.7 = 1 Then
 Portd.6 = 1
 Print "an"
 Else
 Portd.6 = 0
 Print "aus"
 End If

Loop