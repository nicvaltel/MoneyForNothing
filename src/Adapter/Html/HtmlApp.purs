module Adapter.Html.HtmlApp where

import Logic.Types(GameState, UserInput(..))
import Prelude

import Control.Monad.Reader (class MonadAsk, class MonadReader, ReaderT, ask, runReaderT)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import GameClass (class GameIO)
import Adapter.Html.HtmlHandler as HtmlHandler


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
  showState gs = liftEffect $ HtmlHandler.printGameMessage $ show gs
  

  displayMessage :: String -> HtmlApp Unit
  -- displayMessage str = liftEffect $ log str
  displayMessage str = liftEffect $ HtmlHandler.printGameMessage str

  getUserInput :: HtmlApp UserInput
  getUserInput = do
    s <- liftAff HtmlHandler.waitForClick
    pure (parseUserInput s)
    where
      parseUserInput :: String -> UserInput
      parseUserInput "btnRollDice" = UserInputRollDice
      parseUserInput x = UserInputOther x