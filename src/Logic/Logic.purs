module Logic.Logic where

import Prelude

import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Effect.Aff (delay)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Random (randomInt)
import GameClass (class GameIO, getUserInput, showState)
import Logic.Params (fieldCicleSIze, maxDice, minDice)
import Logic.Types (GameState, UserInput(..))


rollDice :: Effect Int
rollDice = randomInt minDice maxDice


processRollDice :: GameState -> Effect GameState
processRollDice gs = do
  dice <- rollDice
  let newPosition = (gs.position + dice) `mod` fieldCicleSIze
  pure gs{position = newPosition}



gameLoop :: forall m. GameIO m => GameState -> m Unit
gameLoop gs = do
  userInput <- getUserInput
  -- input <- do 
  --   liftAff $ delay (Milliseconds 0.1) 
  --   pure (UserInput "Hello")
  liftEffect $ log $ "PRESSED: " <> show userInput
  case userInput of
    UserInputRollDice -> do
      gs1 <- liftEffect $ processRollDice gs
      let newGs = gs1{step = gs1.step + 1}
      showState newGs
      gameLoop newGs
    UserInputOther _ -> gameLoop gs
