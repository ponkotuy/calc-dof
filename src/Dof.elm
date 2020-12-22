module Dof exposing (..)

import Numeral exposing (format)

before fValue length focal =
  acceptableCircle * fValue * length * length / (focal * focal + acceptableCircle * fValue * length)

after fValue length focal =
  acceptableCircle * fValue * length * length / (focal * focal - acceptableCircle * fValue * length)

-- 過焦点距離
overfocus fValue focal =
  focal + focal * focal / (acceptableCircle * fValue)

-- 許容錯乱円
acceptableCircle = 1.0 / 60.0

-- 錯乱径
confusionLength fValue length focal target =
  focal * focal * target / ((length - focal) * (length - focal - target) * -fValue)

milliMeter = format "0,0 [mm]"
