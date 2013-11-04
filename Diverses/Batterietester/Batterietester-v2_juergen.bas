''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''' Copyright (c) by Florian Asche ''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''

$regfile = "m8def.dat"
$crystal = 12000000
$baud = 9600


Config Adc = Single , Prescaler = Auto , Reference = Internal
Start Adc

Dim W As Word
Dim V As Single
Config Portb = Output
Do

   W = Getadc(0)
   V = W * 0.0025
   If W > 250 Then
     If V < 1.7 Then
       If V > 1.55 Then
           Portb = 63
       Elseif V > 1.5 Then
           Portb = 31
       Elseif V > 1.4 Then
           Portb = 15
       Elseif V > 1.3 Then
           Portb = 7
       Elseif V > 1.2 Then
           Portb = 3
       Elseif V > 1.1 Then
           Portb = 1
       Else
           Portb = 0
       End If
     Else
       V = 0
       'W = 0
       Portb = 0
     End If
   Else
       'W = 0
       V = 0
   End If
Print V ; " Volt  und  " ; W ; " ADC"
Waitms 1000
Loop

End