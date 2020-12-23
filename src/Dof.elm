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

-- ある物体を画角の半分に写し背景をボカすのに必要なF値
neededFValueFromLength focal acceptable formatWide objLength =
  focal / (2 * objLength * acceptable / formatWide - acceptable)

milliMeter = format "0,0 [mm]"
