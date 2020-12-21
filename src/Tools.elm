module Tools exposing (..)

defaultFValue = 1.4
defaultFocal = 24

fValues = [0.95, 1.4, 1.8, 2.8, 4, 5.6, 8, 11, 16, 22]
lengths = [100, 150, 200, 300, 500, 700, 1000, 1500, 2000, 3000, 5000, 7000, 10000, 15000, 20000, 30000, 50000, 70000, 100000]
focals = [7, 14, 24, 28, 35, 50, 70, 100, 200, 400, 600, 800]

fValueStrs = List.map String.fromFloat fValues
lengthStrs = List.map String.fromInt lengths
focalsStr = List.map String.fromInt focals
