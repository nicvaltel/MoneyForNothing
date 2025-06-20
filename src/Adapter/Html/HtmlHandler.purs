module Adapter.Html.HtmlHandler
  ( displayButton
  , displayGameStatus
  , hideAllButtons
  , hideButton
  , printGameMessage
  , printToActionBox
  , setButtonText
  , waitForClick
  )
  where


import Prelude
import Control.Promise (Promise, toAffE)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Console (log)
import Options.Applicative.Internal.Utils(lines)
import Data.Foldable (traverse_)

type ButtonIdx = String

foreign import _waitForClick :: Effect (Promise String)
foreign import _hideButton :: ButtonIdx -> Effect Unit
foreign import _displayButton :: ButtonIdx -> Effect Unit
foreign import _setButtonText :: ButtonIdx -> String -> Effect Unit
foreign import _printGameMessage :: String -> Effect Unit
foreign import _displayGameStatus :: Array String -> Effect Unit
foreign import _printToActionBox :: Array String -> Effect Unit
foreign import _hideAllButtons :: Effect Unit


-- wrap into Aff
waitForClick ∷ Aff String
waitForClick = toAffE _waitForClick 


hideButton ∷ ButtonIdx → Effect Unit
hideButton = _hideButton

hideAllButtons :: Effect Unit
hideAllButtons = _hideAllButtons

displayButton ∷ ButtonIdx → Effect Unit
displayButton = _displayButton

setButtonText ∷ ButtonIdx → String → Effect Unit
setButtonText = _setButtonText


printGameMessage :: String -> Effect Unit
printGameMessage msg = traverse_ _printGameMessage (lines msg)

displayGameStatus :: String -> Effect Unit
displayGameStatus = _displayGameStatus <<< lines

printToActionBox :: String -> Effect Unit
printToActionBox = _printToActionBox <<< lines


-------------- EXAMPLE --------------
-------------- JS --------------
-- const wait = ms => new Promise(resolve => setTimeout(resolve, ms));

-- export const sleepImpl = ms => () =>
--   wait(ms);

-------------- PUSESCRIPT --------------

-- foreign import sleepImpl :: Int -> Effect (Promise Unit)

-- sleep :: Int -> Aff Unit
-- sleep = sleepImpl >>> toAffE


-- runTest :: Effect Unit
-- runTest = launchAff_ do
--   liftEffect $ log "waiting"
--   sleep(2000)
--   liftEffect $ log "done waiting"
