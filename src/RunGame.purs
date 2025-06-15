module RunGame where

import Prelude

import Adapter.Html.HtmlApp as HtmlApp
import Adapter.Html.HtmlGuiApp as HtmlGuiApp
import Control.Monad.Reader (runReaderT)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log)
import Logic.Logic (gameLoop)
import Logic.Params (initialGameState)
import Logic.Types (GameState, UserInput)


type AppIOFunctions = 
  { showState :: GameState -> Effect Unit
  , displayMessage :: String -> Effect Unit
  , getUserInput :: Effect UserInput
  }


runGameLoopHtmlGuiApp :: Effect Unit
runGameLoopHtmlGuiApp = do
  log "HtmlGuiApp!"
  launchAff_ $
    runReaderT (HtmlGuiApp.unHtmlGuiApp $ gameLoop initialGameState) {}


runGameLoopHtmlApp :: Effect Unit
runGameLoopHtmlApp = do
  launchAff_ $
    runReaderT (HtmlApp.unHtmlApp $ gameLoop initialGameState) {}