module Utils.Utils where

import Prelude

import Effect.Class.Console (error)
import Unsafe.Coerce (unsafeCoerce)



undefined = do 
  error "undefined"
  unsafeCoerce unit
