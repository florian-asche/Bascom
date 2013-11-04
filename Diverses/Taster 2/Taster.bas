''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''' Copyright (c) by Florian Asche ''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''

$regfile = "m8def.dat"
$crystal = 1200000

Config Portd = Output
Config Pinc.0 = Input
Dim Status As Bit
Status = 0


Do
If Pinc.0 = 0 Then
If Status = 1 Then
Status = 0
Else
Status = 1
End If
End If

If Status = 0 Then
Portd = 255
Else
Portd = 0
End If
Waitms 200
Loop

