''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''' Copyright (c) by Florian Asche ''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''

$regfile = "m8def.dat"
$crystal = 12000000
Dim Wert As Integer
Dim I As Integer

Config Portd = Output
Wert = 1
I = 1

Do
   For I = 1 To 8
     Portd = Wert
     Wert = Wert * 2
     Waitms 150
   Next
   Wert = 1

Loop