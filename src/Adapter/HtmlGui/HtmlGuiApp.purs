module Adapter.Html.HtmlGuiApp where

import Prelude

import Adapter.HtmlGui.HtmlGuiHandler as HtmlGuiHandler
import Control.Monad.Reader (class MonadAsk, class MonadReader, ReaderT, ask, runReaderT)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Logic.GameClass
import Logic.Types (FieldType(..), GameState, UserInput(..), Work(..), prettyGameState)
import Logic.WorkParams (jobClerk)
import Data.Map as Map


type HtmlGuiAppData = {}
data HtmlGuiApp a = HtmlGuiApp (ReaderT HtmlGuiAppData Aff a)

unHtmlGuiApp :: forall a. HtmlGuiApp a -> ReaderT HtmlGuiAppData Aff a
unHtmlGuiApp (HtmlGuiApp readerT) = readerT

instance functor :: Functor HtmlGuiApp where
  map f (HtmlGuiApp x) = HtmlGuiApp (map f x)

instance applyHtmlGuiApp :: Apply HtmlGuiApp where
  -- apply (HtmlGuiApp f) (HtmlGuiApp x) = HtmlGuiApp (apply f x)
  apply = ap

instance applicativeHtmlGuiApp :: Applicative HtmlGuiApp where
  pure x = HtmlGuiApp (pure x)

instance bindHtmlGuiApp :: Bind HtmlGuiApp where
  bind (HtmlGuiApp rT) k = HtmlGuiApp $ do
    x <- rT
    unHtmlGuiApp (k x)

instance monadHtmlGuiApp :: Monad HtmlGuiApp

instance monadEffectHtmlGuiApp :: MonadEffect HtmlGuiApp where
  liftEffect = HtmlGuiApp <<< liftEffect

instance monadAffHtmlGuiApp :: MonadAff HtmlGuiApp where
  liftAff = HtmlGuiApp <<< liftAff

instance monadAskHtmlGuiApp :: MonadAsk HtmlGuiAppData HtmlGuiApp where
  ask = HtmlGuiApp ask

instance monadReaderHtmlGuiApp :: MonadReader HtmlGuiAppData HtmlGuiApp where
  local f (HtmlGuiApp rT) = HtmlGuiApp $ do
    e <- ask
    x <- rT
    runReaderT (pure x) (f e)

instance gameIOHtmlGuiApp :: GameIO HtmlGuiApp where
  showState :: GameState -> HtmlGuiApp Unit
  showState gs = liftEffect $ HtmlGuiHandler.displayGameStatus $ prettyGameState gs

  displayMessage :: String -> HtmlGuiApp Unit
  displayMessage str = liftEffect $ HtmlGuiHandler.printGameMessage str

  getUserInput :: Maybe (String -> Maybe UserInput) ->  HtmlGuiApp UserInput
  getUserInput mayInputParser = do
    s <- liftAff HtmlGuiHandler.waitForClick
    case mayInputParser of
      Nothing -> pure (parseUserInput s)
      Just parser -> case parser s of
        Just input -> pure input
        Nothing -> pure (parseUserInput s)
    where
      parseUserInput :: String -> UserInput
      parseUserInput "btnRollDice" = UserInputRollDice
      parseUserInput "btnStudy" = UserInputStudy
      parseUserInput "btnWork" = UserInputWork (Job jobClerk)
      parseUserInput "btnDoRandomEvent" = UserInputDoRandomEvent
      parseUserInput "btnLeaveJob" = UserInputLeaveJob jobClerk.name
      parseUserInput x = UserInputOther x

  hideAllButtons = liftEffect HtmlGuiHandler.hideAllButtons

  displayButton btnName = liftEffect $ HtmlGuiHandler.displayButton btnName

  printToActionBox = liftEffect <<< HtmlGuiHandler.printToActionBox

  showAvailableAction :: GameState -> HtmlGuiApp Unit
  showAvailableAction gs =
    case gs.fieldType of
      FieldWork -> printToActionBox $ show jobClerk
      _ -> pure unit


  hideUnusedButtons :: GameState -> HtmlGuiApp Unit
  hideUnusedButtons gs = do
      hideAllButtons
      displayButton btnRollDice
      when (not $ Map.isEmpty gs.works.jobs) $ displayButton btnLeaveJob
      showUsedBtn gs.fieldType
      where
        showUsedBtn FieldStudy = displayButton btnStudy
        showUsedBtn FieldWork = displayButton btnWork
        showUsedBtn FieldRandomEvent = displayButton btnDoRandomEvent
        showUsedBtn FieldActionComplete = pure unit


btnRollDice = "btnRollDice" :: String
btnStudy = "btnStudy" :: String
btnWork = "btnWork" :: String
btnDoRandomEvent = "btnDoRandomEvent" :: String
btnLeaveJob = "btnLeaveJob" :: String