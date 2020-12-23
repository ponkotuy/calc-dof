module Format exposing (..)

type Format = MicroFourThirds | APS_C | FullSize

type alias FormatSize = { x: Float, y: Float }

defaultFormat = MicroFourThirds

formatSize : Format -> FormatSize
formatSize format =
  case format of
    MicroFourThirds -> { x = 17.4, y = 13.0 }
    APS_C -> { x = 23.5, y = 15.6 }
    FullSize -> { x = 36.0, y = 24.0 }

fromString : String -> Maybe Format
fromString str =
  case str of
    "MFT" -> Just MicroFourThirds
    "APSC" -> Just APS_C
    "FullSize" -> Just FullSize
    _ -> Nothing
