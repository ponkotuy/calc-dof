module Dof exposing (..)

import Numeral exposing (format)

before fValue length focal =
  acceptable_circle * fValue * length * length / (focal * focal + acceptable_circle * fValue * length)

after fValue length focal =
  acceptable_circle * fValue * length * length / (focal * focal - acceptable_circle * fValue * length)

acceptable_circle = 1.0 / 60.0

milliMeter = format "0,0 [mm]"
