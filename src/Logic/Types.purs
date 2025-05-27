module Logic.Types where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Data.String (Pattern(..), Replacement(..), replaceAll)


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
  , intellect :: Number
  , freeTime :: Int
  , absPosition :: Int
  , lastSalary :: Int
  , position :: Int
  , fieldType :: FieldType
  , step :: Int
  , work :: Int
  , study :: Int
  , randomEvents :: Int
  }

prettyGameState :: GameState -> String
prettyGameState gs = 
  replaceAll (Pattern ",") (Replacement ",\n") (show gs)

data UserInput = 
    UserInputRollDice
  | UserInputStudy
  | UserInputWork
  | UserInputDoRandomEvent
  | UserInputLeaveWork
  | UserInputOther String

derive instance eqUserInput :: Eq UserInput
derive instance genericUserInput :: Generic UserInput _
instance showUserInput :: Show UserInput where
  show = genericShow


data FieldType =
    FieldStudy
  | FieldWork
  | FieldRandomEvent
  | FieldActionComplete

derive instance eqFieldType :: Eq FieldType
derive instance genericFieldType :: Generic FieldType _
instance showFieldType :: Show FieldType where
  show = genericShow
