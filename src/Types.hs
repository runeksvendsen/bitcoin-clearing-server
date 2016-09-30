module Types
(
    module Types.Crypto
  , BS.ByteString
  , T.Text
  , HasID(..)
  , UUID
  , AppM
--   , UUID(..)
--   , getHash
)
where

import           Types.UUID
import           Types.Crypto

import qualified Data.Text as T
import qualified Data.ByteString as BS

import qualified Control.Monad.Reader as Reader
import qualified Servant



-- |We use this monad for the handlers, which gives access to configuration data
--  of type 'conf'.
type AppM conf = Reader.ReaderT conf Servant.Handler
