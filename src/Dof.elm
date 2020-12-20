module Dof exposing (..)

import Numeral exposing (format)

before fValue length focal =
  acceptableCircle * fValue * length * length / (focal * focal + acceptableCircle * fValue * length)

after fValue length focal =
  acceptableCircle * fValue * length * length / (focal * focal - acceptableCircle * fValue * length)

-- 過焦点距離
overfocus fValue focal =
  focal * focal / (acceptableCircle * fValue)

acceptableCircle = 1.0 / 60.0

milliMeter = format "0,0 [mm]"
