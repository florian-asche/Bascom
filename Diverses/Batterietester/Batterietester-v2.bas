''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''' Copyright (c) by Florian Asche ''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''

Config Adc = Single , Prescaler = Auto , Reference = Internal
Start Adc

Dim W As Word
Dim V As Single
Config Portd = Output
Do

   W = Getadc(5)
   V = W * 0.0025
   If W > 250 Then
     If V < 1.6 Then
       If V > 1.5 Then
           Portd = 255
       Elseif V > 1.45 Then
           Portd = 127
       Elseif V > 1.35 Then
           Portd = 63
       Elseif V > 1.3 Then
           Portd = 31
       Elseif V > 1.2 Then
           Portd = 2
       Else
           Portd = 0
       End If
     Else
       V = 0
       W = 0
       Portd = 0
     End If
   Else
       W = 0
       V = 0
   End If
Print V ; " Volt  und  " ; W ; " ADC"
Waitms 1000
Loop

End

