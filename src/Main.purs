module Main where
-- spago bundle-app --main Main --to ./html/scripts/app.js

import Prelude

import Effect (Effect)
import Effect.Console (log)
import RunGame as RunGame
import Logic.Logic as Logic

main :: Effect Unit
main = do
  log "🍝"
  -- Logic.runGameLoop
  RunGame.runGameLoop
