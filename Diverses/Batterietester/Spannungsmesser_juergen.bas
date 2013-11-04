''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''' Copyright (c) by Florian Asche ''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''

$regfile = "m8def.dat"

$baud = 9600                                                'Baudrate festlegen

Config Adc = Single , Prescaler = Auto , Reference = Internal       'Takt(teiler) f�r den ADC automatisch festlegen

Start Adc

Dim W As Word , Erg As Single                               'Speicher f�r den Spannungswert

Do
W = Getadc(0)
Erg = W / 400                                               'Spannungswert in W schreiben
Print "Spannung: " ; Erg
waitms 200                                    'Wert auf RS232 ausgeben
Loop
End