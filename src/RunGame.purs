module RunGame where

import Prelude

import Adapter.Html.HtmlApp (unHtmlApp)
import Control.Monad.Reader (runReaderT)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Logic.Logic (gameLoop)
import Logic.Params (initialGameState)
import Logic.Types (GameState, UserInput)


type AppIOFunctions = 
  { showState :: GameState -> Effect Unit
  , displayMessage :: String -> Effect Unit
  , getUserInput :: Effect UserInput
  }



runGameLoop :: Effect Unit
runGameLoop = do
  launchAff_ $
    runReaderT (unHtmlApp $ gameLoop initialGameState) {}