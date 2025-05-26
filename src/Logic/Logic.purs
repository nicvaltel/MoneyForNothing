module Logic.Logic where

import Prelude

import Effect (Effect)
import Effect.Random (randomInt)
import Logic.Params (fieldCicleSIze, initialGameState, maxDice, minDice)
import Logic.Types (GameState)

rollDice :: Effect Int
rollDice = randomInt minDice maxDice


processRollDice :: GameState -> Effect GameState
processRollDice gs = do
  dice <- rollDice
  let newPosition = (gs.position + dice) `mod` fieldCicleSIze
  pure gs{position = newPosition}

