module Dof exposing (..)

import Numeral exposing (format)

before fValue length focal acceptable =
  acceptable * fValue * length * length / (focal * focal + acceptable * fValue * length)

after fValue length focal acceptable =
  acceptable * fValue * length * length / (focal * focal - acceptable * fValue * length)

-- 過焦点距離
overfocus fValue focal acceptable =
  focal + focal * focal / (acceptable * fValue)

-- 錯乱径
confusionLength fValue length focal target =
  abs (focal * focal * (length - target) / ((length - focal) * (target - focal) * fValue))

milliMeter = format "0,0 [mm]"

acceptableMilli = format "0,0.000 [mm]"
