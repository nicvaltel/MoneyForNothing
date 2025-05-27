module Logic.Logic where

import GameClass
import Logic.Params
import Prelude

import Data.Int (toNumber)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Random (randomInt)
import Logic.Types (FieldType(..), UserInput(..), GameState)


rollDice :: Effect Int
rollDice = randomInt minDice maxDice


processRollDice :: GameState -> Effect GameState
processRollDice gs = do
  dice <- rollDice
  let newAbsPosition = gs.position + dice
  let newPosition = newAbsPosition `mod` fieldCicleSIze
  pure gs{position = newPosition, absPosition = newAbsPosition}


availableActionsFSM :: FieldType -> UserInput -> GameState -> GameState
availableActionsFSM FieldStudy UserInputStudy gs | gs.freeTime >= studyTimeCost = 
      gs{ study = gs.study + 1
        , freeTime = gs.freeTime - studyTimeCost
        , fieldType = FieldActionComplete
        }
availableActionsFSM FieldWork UserInputWork gs | gs.freeTime >= workTimeCost = 
      gs{ work = gs.work + 1
        , freeTime = gs.freeTime - workTimeCost
        , fieldType = FieldActionComplete
        } 
availableActionsFSM FieldRandomEvent UserInputDoRandomEvent gs = gs{randomEvents = gs.randomEvents + 1, fieldType = FieldActionComplete}
availableActionsFSM _ UserInputLeaveWork gs | gs.work >= 1 =
  gs{ work = gs.work - 1
    , freeTime = gs.freeTime + workTimeCost
    } 
availableActionsFSM _ _ gs = gs

paySalary :: GameState -> GameState
paySalary gs = 
  if gs.absPosition - gs.lastSalary >= salaryTimeInterval
    then gs{ money = gs.money + workSalary * toNumber gs.work
           , intellect = gs.intellect + studySalary * toNumber gs.study
           , lastSalary = gs.absPosition - gs.absPosition `mod` salaryTimeInterval}
    else gs

gameLoop :: forall m. GameIO m => GameState -> m Unit
gameLoop gs0 = do
  let gs = paySalary gs0
  showState gs
  hideUnusedButtons gs
  userInput <- getUserInput
  liftEffect $ log $ "PRESSED: " <> show userInput
  case userInput of
    UserInputRollDice -> do
      gs1 <- liftEffect $ processRollDice gs
      let newFieldType = positionToFieldType gs1.position
      displayMessage ("Field: " <> show newFieldType)
      let newGs = gs1{step = gs1.step + 1, fieldType = newFieldType}
      gameLoop newGs
    UserInputOther _ -> gameLoop gs
    _ -> do
      let newGs = availableActionsFSM (positionToFieldType gs.position) userInput gs      
      gameLoop newGs


hideUnusedButtons :: forall m. GameIO m => GameState -> m Unit
hideUnusedButtons gs = do
    hideAllButtons
    displayButton btnRollDice
    when (gs.work >= 1) $ displayButton btnLeaveWork
    showUsedBtn gs.fieldType
    where
      showUsedBtn FieldStudy = displayButton btnStudy
      showUsedBtn FieldWork = displayButton btnWork
      showUsedBtn FieldRandomEvent = displayButton btnDoRandomEvent
      showUsedBtn FieldActionComplete = pure unit
