module RunGame where

-- import Adapter.Terminal.Terminal

import GameClass
import Prelude

import Adapter.Html.HtmlHandler as HtmlHandler
import Control.Monad.Reader (class MonadAsk, class MonadReader, ReaderT, ask, runReaderT)
import Control.Monad.Rec.Class (forever)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Ref (new, read, write)
import Logic.Logic (processRollDice)
import Logic.Params (initialGameState)
import Logic.Types (GameState, UserInput(..))
import Unsafe.Coerce (unsafeCoerce)
import Utils.Utils (undefined)



type AppIOFunctions = 
  { showState :: GameState -> Effect Unit
  , displayMessage :: String -> Effect Unit
  , getUserInput :: Effect UserInput
  }


gameLoop :: GameState -> Aff Unit
gameLoop gs = do
  s <- HtmlHandler.waitForClick
  liftEffect $ log $ "PRESSED: " <> s
  newGs <- liftEffect $ processRollDice gs
  liftEffect $ HtmlHandler.printGameMessage $ show newGs
  
  gameLoop newGs


runGameLoop :: Effect Unit
runGameLoop = do
  launchAff_ $ gameLoop initialGameState