module Logic.Params where

import Prelude

import Logic.Types(GameState)


minDice = 1 :: Int

maxDice = 6 :: Int

fieldCicleSIze = 100 :: Int


initialGameState :: GameState
initialGameState =
  { player : {name: "Username", age: 27}
  , money : 600.0
  , position : 0
  , step : 0
  }