$regfile = "m8def.dat"
$crystal = 12000000
$baud A = 9600

Config Adc = Single , Prescaler = Auto , Reference = Internal
Start Adc

Config Pind.5 = Input
Config Pind.6 = Input
Config Pind.7 = Input
Config Portb.1 = Output
Config Portb.5 = Output
Dim Schalter As Bit
Dim W As Word
Dim P As Single

Schalter = 0
W = 0
P = 0
Portb.5 = 0
Portb.1 = 0

Do

   If Pind.7 = 0 Then
      Waitms 200
      If Schalter = 0 Then
         Schalter = 1
      Else
         Schalter = 0
      End If
      Portb.1 = Schalter
   End If

   If Pind.6 = 0 And Pind.5 = 0 And Schalter = 1 Then
      Portb.5 = 1
      W = Getadc(0)
      P = W / 10.23
      Print P ; "% Staerke"
      Wait 1
   Else
      Portb.5 = 0
   End If

Loop

End