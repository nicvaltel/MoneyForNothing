module Logic.Logic where

import GameClass
import Prelude

import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Effect.Aff (delay)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Random (random, randomInt)
import Logic.Params 
import Logic.Types (FieldType(..), GameState, UserInput(..))


rollDice :: Effect Int
rollDice = randomInt minDice maxDice


processRollDice :: GameState -> Effect GameState
processRollDice gs = do
  dice <- rollDice
  let newPosition = (gs.position + dice) `mod` fieldCicleSIze
  pure gs{position = newPosition}


availableActionsFSM :: FieldType -> UserInput -> GameState -> GameState
availableActionsFSM FieldStudy UserInputStudy gs = gs{study = gs.study + 1, fieldType = FieldActionComplete}
availableActionsFSM FieldWork UserInputWork gs = gs{work = gs.work + 1, fieldType = FieldActionComplete}
availableActionsFSM FieldRandomEvent UserInputDoRandomEvent gs = gs{randomEvents = gs.randomEvents + 1, fieldType = FieldActionComplete}
availableActionsFSM _ _ gs = gs

gameLoop :: forall m. GameIO m => GameState -> m Unit
gameLoop gs = do
  hideUnusedButtons gs.fieldType
  userInput <- getUserInput
  -- input <- do 
  --   liftAff $ delay (Milliseconds 0.1) 
  --   pure (UserInput "Hello")
  liftEffect $ log $ "PRESSED: " <> show userInput
  case userInput of
    UserInputRollDice -> do
      gs1 <- liftEffect $ processRollDice gs
      let newFieldType = positionToFieldType gs1.position
      displayMessage ("Field: " <> show newFieldType)
      let newGs = gs1{step = gs1.step + 1, fieldType = newFieldType}
      showState newGs
      gameLoop newGs
    UserInputOther _ -> gameLoop gs
    _ -> do
      let newGs = availableActionsFSM (positionToFieldType gs.position) userInput gs      
      gameLoop newGs


hideUnusedButtons :: forall m. GameIO m => FieldType -> m Unit
hideUnusedButtons ftype = do
    hideAllButtons
    displayButton btnRollDice
    showUsedBtn ftype
    where
      -- showUsedBtn :: forall m. GameIO m => FieldType -> m Unit
      showUsedBtn FieldStudy = displayButton btnStudy
      showUsedBtn FieldWork = displayButton btnWork
      showUsedBtn FieldRandomEvent = displayButton btnDoRandomEvent
      showUsedBtn FieldActionComplete = pure unit
