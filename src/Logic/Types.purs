module Logic.Types where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Map (Map)
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
  , works :: Works
  , study :: Int
  , randomEvents :: Int
  }

prettyGameState :: GameState -> String
prettyGameState gs = 
  replaceAll (Pattern ",") (Replacement ",\n") (show gs)

data UserInput = 
    UserInputRollDice
  | UserInputStudy
  | UserInputWork Work
  | UserInputDoRandomEvent
  | UserInputLeaveJob String
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


type JobType = 
  { name :: String
  , hours :: Int
  , money :: Number
  }

type BusinessType =
  { name :: String
  , hours :: Int
  , money :: Number
  }

data Work =
    Job JobType
  | Business BusinessType
  | StockMarket

derive instance eqWork :: Eq Work
derive instance genericWork :: Generic Work _
instance showWork :: Show Work where
  show = genericShow

type Works =
  { jobs :: Map String JobType
  , businesses :: Map String BusinessType
  }