''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''' Copyright (c) by Florian Asche ''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''

Config Adc = Single , Prescaler = Auto , Reference = Internal
Start Adc

Dim W As Word
Dim V As Single

Do
   W = Getadc(5)
   V = W * 0.0025
   Print V ; " Volt"
   Waitms 1000
Loop

End

