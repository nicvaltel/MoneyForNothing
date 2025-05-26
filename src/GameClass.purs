module GameClass where

import Prelude

import Control.Monad.Reader (class MonadAsk, class MonadReader, ReaderT)
import Effect (Effect)
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Effect.Console (log)
import Effect.Random (randomInt)
import Logic.Types (GameState, UserInput(..))



class (MonadEffect m) <= GameIO m  where
  showState :: GameState -> m Unit
  displayMessage :: String -> m Unit
  getUserInput :: m UserInput


