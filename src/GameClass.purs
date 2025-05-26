module GameClass where

import Prelude


import Effect.Class (class MonadEffect)
import Logic.Types (GameState, UserInput)



class (MonadEffect m) <= GameIO m  where
  showState :: GameState -> m Unit
  displayMessage :: String -> m Unit
  getUserInput :: m UserInput


