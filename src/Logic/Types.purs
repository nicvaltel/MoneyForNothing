module Logic.Types where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)


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
  , step :: Int
  }


data UserInput = 
    UserInputRollDice
  | UserInputOther String

derive instance eqUserInput :: Eq UserInput

derive instance genericUserInput :: Generic UserInput _

instance showUserInput :: Show UserInput where
  show = genericShow