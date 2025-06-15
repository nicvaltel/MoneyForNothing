module Main where
-- spago bundle-app --main Main --to ./static/html/scripts/app.js

import Prelude

import Effect (Effect)
import Effect.Console (log)
import RunGame as RunGame

main :: Effect Unit
main = do
  log "🍝"
  -- RunGame.runGameLoopHtmlApp
  RunGame.runGameLoopHtmlGuiApp
