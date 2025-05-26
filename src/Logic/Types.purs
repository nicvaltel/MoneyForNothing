module Logic.Types where

import Prelude


data Action =
  RollDice

derive instance eqAction :: Eq Action


type Player =
  { name :: String
  , age :: Int
  }

type GameState =
  { player :: Player
  , money :: Number
  , position :: Int
  }


data UserInput = UserInput String