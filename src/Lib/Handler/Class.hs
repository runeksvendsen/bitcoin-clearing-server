
module Lib.Handler.Class where

import           Types

-- |Class for HTTP requests that can be handled, with a request body
--   of type 'req' and a response of type 'res', with a config of type
--   'conf' available in the handlers.
class HasHandler req res conf where
    handle :: req -> AppM conf res