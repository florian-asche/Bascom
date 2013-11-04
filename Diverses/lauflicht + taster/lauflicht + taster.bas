''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''' Copyright (c) by Florian Asche ''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''

$regfile = "m8def.dat"
$crystal = 12000000
Dim Wert As Integer
Wert = 0

Config Portd = Output
Config Pinb.0 = Input
Taster Alias Pinb.0
Wert = 1

Do
   If Taster = 0 Then
      Wert = Wert * 2
   End If
   If Wert = 256 Then
      Wert = 1
   End If
   Portd = Wert
   Waitms 150
Loop