''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''' Copyright (c) by Florian Asche ''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''

$regfile = "m8def.dat"
$crystal = 12000000
Dim Wert As Integer

Config Portd = Output
Config Pinb.0 = Input
Taster Alias Pinb.0
Wert = 0

Do
   If Taster = 0 Then
      If Wert = 0 Then
         Wert = 15
      Elseif Wert = 15 Then
         Wert = 255
      Elseif Wert = 255 Then
         Wert = 0
      End If
   End If
   Portd = Wert
   Waitms 150
Loop
