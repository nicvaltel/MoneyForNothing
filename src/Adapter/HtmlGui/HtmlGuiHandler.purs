module Adapter.HtmlGui.HtmlGuiHandler where

import Prelude
import Prelude

import Control.Promise (Promise, toAffE)
import Data.Foldable (traverse_)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Console (log)
import Options.Applicative.Internal.Utils (lines)
import Utils.Utils (undefined)

type ButtonIdx = String

foreign import _displayGameStatus :: Array String -> Effect Unit
foreign import _waitForClick :: Effect (Promise String)
-- foreign import _hideButton :: ButtonIdx -> Effect Unit
foreign import _displayButton :: ButtonIdx -> Effect Unit
-- foreign import _setButtonText :: ButtonIdx -> String -> Effect Unit
foreign import _printGameMessage :: String -> Effect Unit
-- foreign import _displayGameStatus :: Array String -> Effect Unitforeign import _printToActionBox :: Array String -> Effect Unit
foreign import _hideAllButtons :: Effect Unit
foreign import _printToActionBox :: Array String -> Effect Unit

displayGameStatus :: String -> Effect Unit
displayGameStatus = _displayGameStatus <<< lines


printGameMessage :: String -> Effect Unit
printGameMessage = _printGameMessage

waitForClick ∷ Aff String
waitForClick = toAffE _waitForClick 

hideAllButtons :: Effect Unit
hideAllButtons = _hideAllButtons

displayButton ∷ ButtonIdx → Effect Unit
displayButton = _displayButton

printToActionBox :: String -> Effect Unit
printToActionBox = _printToActionBox <<< lines