module Adapter.Html.HtmlApp where

import Prelude

import Adapter.Html.HtmlHandler as HtmlHandler
import Control.Monad.Reader (class MonadAsk, class MonadReader, ReaderT, ask, runReaderT)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import GameClass (class GameIO)
import Logic.Types (GameState, UserInput(..), Work(..), prettyGameState)
import Logic.WorkParams (jobClerk)


type HtmlAppData = {}
data HtmlApp a = HtmlApp (ReaderT HtmlAppData Aff a)

unHtmlApp :: forall a. HtmlApp a -> ReaderT HtmlAppData Aff a
unHtmlApp (HtmlApp readerT) = readerT

instance functor :: Functor HtmlApp where
  map f (HtmlApp x) = HtmlApp (map f x)

instance applyHtmlApp :: Apply HtmlApp where
  -- apply (HtmlApp f) (HtmlApp x) = HtmlApp (apply f x)
  apply = ap

instance applicativeHtmlApp :: Applicative HtmlApp where
  pure x = HtmlApp (pure x)

instance bindHtmlApp :: Bind HtmlApp where
  bind (HtmlApp rT) k = HtmlApp $ do
    x <- rT
    unHtmlApp (k x)

instance monadHtmlApp :: Monad HtmlApp

instance monadEffectHtmlApp :: MonadEffect HtmlApp where
  liftEffect = HtmlApp <<< liftEffect

instance monadAffHtmlApp :: MonadAff HtmlApp where
  liftAff = HtmlApp <<< liftAff

instance monadAskHtmlApp :: MonadAsk HtmlAppData HtmlApp where
  ask = HtmlApp ask

instance monadReaderHtmlApp :: MonadReader HtmlAppData HtmlApp where
  local f (HtmlApp rT) = HtmlApp $ do
    e <- ask
    x <- rT
    runReaderT (pure x) (f e)

instance gameIOHtmlApp :: GameIO HtmlApp where
  showState :: GameState -> HtmlApp Unit
  -- showState gs = liftEffect $ log $ show gs
  showState gs = liftEffect $ HtmlHandler.displayGameStatus $ prettyGameState gs
  

  displayMessage :: String -> HtmlApp Unit
  -- displayMessage str = liftEffect $ log str
  displayMessage str = liftEffect $ HtmlHandler.printGameMessage str

  getUserInput :: Maybe (String -> Maybe UserInput) ->  HtmlApp UserInput
  getUserInput mayInputParser = do
    s <- liftAff HtmlHandler.waitForClick
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

  hideAllButtons = liftEffect HtmlHandler.hideAllButtons

  displayButton btnName = liftEffect $ HtmlHandler.displayButton btnName