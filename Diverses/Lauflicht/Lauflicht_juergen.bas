''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''' Copyright (c) by Florian Asche ''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''

$regfile = "m8def.dat"
$crystal = 12000000

Config Portd = Output

Dim I As Integer

Do
   For I = 0 To 7
      Portd = 2 ^ I
      Waitms 100
   Next
   For I = 0 To 5
      Portd = Portd / 2
      Waitms 100
   Next
Loop

End