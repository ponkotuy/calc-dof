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

fromString : String -> Format
fromString str =
  case str of
    "MFT" -> MicroFourThirds
    "APSC" -> APS_C
    "FullSize" -> FullSize
