module Tools exposing (..)

type alias WithDetail =
 { value: Float, detail: String }

defaultFValue = 1.4
defaultLength = 1000
defaultFocal = 24
defaultAcceptable = 0.015 -- 許容錯乱円

fValues = [0.95, 1.4, 1.8, 2.8, 4, 5.6, 8, 11, 16, 22]
lengths = [100, 150, 200, 300, 500, 700, 1000, 1500, 2000, 3000, 5000, 7000, 10000, 15000, 20000, 30000, 50000, 70000, 100000]
focals = [7, 14, 24, 28, 35, 50, 70, 100, 200, 400, 600, 800]
acceptables : List WithDetail
acceptables =
  [ { value = 0.1, detail = "ボケを認識できる" }
  , { value = 0.03, detail = "フルサイズでシャープ" }
  , { value = 0.02, detail = "APS-Cでシャープ" }
  , { value = 0.015, detail = "M4/3でシャープ" }
  , { value = 0.0082, detail = "α7Cの画素サイズ" }
  , { value = 0.0059, detail = "Z50の画素サイズ"}
  , { value = 0.0052, detail = "α7RIVの画素サイズ" }
  , { value = 0.0046, detail = "GX7MK3の画素サイズ" }
  ]

fValueStrs = List.map String.fromFloat fValues
lengthStrs = List.map String.fromInt lengths
focalsStr = List.map String.fromInt focals
acceptableStr : WithDetail -> String
acceptableStr a = String.fromFloat a.value
