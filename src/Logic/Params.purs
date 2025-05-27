module Logic.Params where

import Prelude

import Effect.Exception (error)
import Logic.Types (FieldType(..), GameState)
import Unsafe.Coerce (unsafeCoerce)

minDice = 1 :: Int

maxDice = 6 :: Int

fieldCicleSIze = 96 :: Int -- 12 monthes * 4 weeks * 2


initialGameState :: GameState
initialGameState =
  { player : {name: "Username", age: 27}
  , money : 600.0
  , intellect : 100.0
  , freeTime : 480
  , absPosition : 0
  , position : 0
  , lastSalary : 0
  , fieldType : FieldActionComplete
  , step : 0
  , work : 0
  , study : 0
  , randomEvents : 0
  }

positionToFieldType :: Int -> FieldType
positionToFieldType n =
  case n `mod` 3 of
    0 -> FieldStudy
    1 -> FieldWork
    2 -> FieldRandomEvent
    _ -> unsafeCoerce $ error "Unexpected `mod` 3"


btnRollDice = "btnRollDice" :: String
btnStudy = "btnStudy" :: String
btnWork = "btnWork" :: String
btnDoRandomEvent = "btnDoRandomEvent" :: String
btnLeaveWork = "btnLeaveWork" :: String


workTimeCost = 100 :: Int
workSalary = 500.0 :: Number

studyTimeCost = 20 :: Int
studySalary = 40.0 :: Number

salaryTimeInterval = 8 :: Int -- 4 weeks in month * 2