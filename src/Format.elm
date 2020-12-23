module Format exposing (..)

type Format = MicroFourThirds | APS_C | FullSize | Medium

type alias FormatSize = { x: Float, y: Float }

defaultFormat = MicroFourThirds

formatSize : Format -> FormatSize
formatSize format =
  case format of
    MicroFourThirds -> { x = 17.4, y = 13.0 }
    APS_C -> { x = 23.5, y = 15.6 }
    FullSize -> { x = 36.0, y = 24.0 }
    Medium -> { x = 43.8, y = 32.9 }

toString : Format -> String
toString format =
  case format of
    MicroFourThirds -> "MFT"
    APS_C -> "APSC"
    FullSize -> "FullSize"
    Medium -> "Medium"

fromString : String -> Maybe Format
fromString str =
  case str of
    "MFT" -> Just MicroFourThirds
    "APSC" -> Just APS_C
    "FullSize" -> Just FullSize
    "Medium" -> Just Medium
    _ -> Nothing

formatName format =
  case format of
    MicroFourThirds -> "マイクロフォーサーズ"
    APS_C -> "APS-C"
    FullSize -> "フルサイズ"
    Medium -> "中判"

all : List Format
all = [MicroFourThirds, APS_C, FullSize, Medium]
