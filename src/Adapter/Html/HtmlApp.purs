module Adapter.Html.HtmlApp where

import Prelude

import Control.Monad.Reader (class MonadAsk, class MonadReader, ReaderT, ask, runReaderT)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Console (log)
import Effect.Ref (Ref, read, write)
import GameClass (class GameIO)
import Utils.Utils (undefined)
import Logic.Types


type HtmlAppData = {}
data HtmlApp a = HtmlApp (ReaderT HtmlAppData Effect a)

unHtmlApp :: forall a. HtmlApp a -> ReaderT HtmlAppData Effect a
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
  -- liftEffect = unsafeCoerce

instance monadAskHtmlApp :: MonadAsk HtmlAppData HtmlApp where
  ask = HtmlApp ask

instance monadReaderHtmlApp :: MonadReader HtmlAppData HtmlApp where
  local f (HtmlApp rT) = HtmlApp $ do
    e <- ask
    x <- rT
    runReaderT (pure x) (f e)

instance gameIOHtmlApp :: GameIO HtmlApp where
  showState :: GameState -> HtmlApp Unit
  showState gs = liftEffect $ log $ show gs

  displayMessage :: String -> HtmlApp Unit
  displayMessage str = liftEffect $ log str

  getUserInput :: HtmlApp UserInput
  getUserInput = undefined