module Types
(
    module Types.Config

  , Pay.RecvPayChanX
  , Pay.BitcoinAmount
  , Pay.SendPubKey(..)
  , Pay.RecvPubKey(..)

  , BS.ByteString
  , T.Text

  , HasUUID(..)
  , UUID

  , AppM

  , BitcoinTx
  , BitcoinAddress
  , Word32, Word64

)
where

import           Types.UUID
import           Types.Config

import qualified Data.Text as T
import qualified Data.ByteString as BS
import qualified Network.Haskoin.Transaction as HT
import qualified Network.Haskoin.Crypto             as HC
import qualified Data.Bitcoin.PaymentChannel.Types as Pay

import qualified Control.Monad.Reader as Reader
import qualified Servant
import           Data.Word (Word32, Word64)

type BitcoinTx = HT.Tx
type BitcoinAddress = HC.Address

-- |We use this monad for the handlers, which gives access to configuration data
--  of type 'conf'.
type AppM conf = Reader.ReaderT conf Servant.Handler
