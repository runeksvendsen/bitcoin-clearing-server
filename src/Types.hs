module Types
(
    module Types.Crypto
  , module Types.Config
  , BS.ByteString
  , T.Text
  , HasUUID(..)
  , UUID
  , AppM
  , BitcoinTx
--   , UUID(..)
--   , getHash
)
where

import           Types.UUID
import           Types.Crypto
import           Types.Config

import qualified Data.Text as T
import qualified Data.ByteString as BS
import qualified Network.Haskoin.Transaction as HT

import qualified Control.Monad.Reader as Reader
import qualified Servant

type BitcoinTx = HT.Tx

-- |We use this monad for the handlers, which gives access to configuration data
--  of type 'conf'.
type AppM conf = Reader.ReaderT conf Servant.Handler
