module Logic.Logic where

import GameClass
import Logic.Params
import Prelude

import Data.Foldable (sum)
import Data.Int (toNumber)
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Random (randomInt)
import Logic.Types (FieldType(..), GameState, UserInput(..), Work(..))


rollDice :: Effect Int
rollDice = randomInt minDice maxDice


processRollDice :: GameState -> Effect GameState
processRollDice gs = do
  dice <- rollDice
  let newAbsPosition = gs.absPosition + dice
  let newPosition = newAbsPosition `mod` fieldCicleSIze
  pure gs{position = newPosition, absPosition = newAbsPosition}


availableActionsFSM :: FieldType -> UserInput -> GameState -> GameState
availableActionsFSM FieldStudy UserInputStudy gs | gs.freeTime >= studyTimeCost = 
      gs{ study = gs.study + 1
        , freeTime = gs.freeTime - studyTimeCost
        , fieldType = FieldActionComplete
        }
availableActionsFSM FieldWork (UserInputWork work) gs = 
  case work of
    Job job | (gs.freeTime >= job.hours) && not (Map.member job.name gs.works.jobs) -> 
      gs{ works = gs.works{jobs = Map.insert job.name job gs.works.jobs}
        , freeTime = gs.freeTime - job.hours
        , fieldType = FieldActionComplete
        } 
    Business _ -> gs
    StockMarket -> gs
    _ -> gs

availableActionsFSM FieldRandomEvent UserInputDoRandomEvent gs = gs{randomEvents = gs.randomEvents + 1, fieldType = FieldActionComplete}
availableActionsFSM _ (UserInputLeaveJob jobName) gs =
  case Map.lookup jobName gs.works.jobs of
    Nothing -> gs
    Just job -> 
      gs { works = gs.works{jobs = Map.delete jobName gs.works.jobs}
         , freeTime = gs.freeTime + job.hours
         } 
availableActionsFSM _ _ gs = gs

paySalary :: GameState -> GameState
paySalary gs = 
  if gs.absPosition - gs.lastSalary >= salaryTimeInterval
    then gs{ money = gs.money + sum (map (\job -> job.money) (Map.values gs.works.jobs))
           , intellect = gs.intellect + studySalary * toNumber gs.study
           , lastSalary = gs.absPosition - gs.absPosition `mod` salaryTimeInterval}
    else gs

gameLoop :: forall m. GameIO m => GameState -> m Unit
gameLoop gs0 = do
  let gs = paySalary gs0
  showState gs
  hideUnusedButtons gs
  userInput <- getUserInput
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
    when (not $ Map.isEmpty gs.works.jobs) $ displayButton btnLeaveJob
    showUsedBtn gs.fieldType
    where
      showUsedBtn FieldStudy = displayButton btnStudy
      showUsedBtn FieldWork = displayButton btnWork
      showUsedBtn FieldRandomEvent = displayButton btnDoRandomEvent
      showUsedBtn FieldActionComplete = pure unit
