module GameClass where

import Prelude

import Data.Maybe (Maybe)
import Effect.Class (class MonadEffect)
import Logic.Types (GameState, UserInput)



class (MonadEffect m) <= GameIO m  where
  showState :: GameState -> m Unit
  displayMessage :: String -> m Unit
  getUserInput :: Maybe (String -> Maybe UserInput) -> m UserInput
  hideAllButtons :: m Unit
  displayButton :: String -> m Unit


