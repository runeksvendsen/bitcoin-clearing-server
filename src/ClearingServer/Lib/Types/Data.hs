module ClearingServer.Lib.Types.Data where

-- import           ClearingServer.Lib.Types
import qualified Data.Bitcoin.PaymentChannel.Types as Pay
import qualified Data.Bitcoin.PaymentChannel.Types as PayChan
import qualified Network.Haskoin.Transaction as HT
import qualified Data.ByteString as BS


type ChannelId  = HT.OutPoint
type Amount     = Pay.BitcoinAmount
-- Stubs
data ListOfLength len a = Stub2
type Identity = ()
type UTCTime = ()
data NonEmptyList a = Stub
type Currency = ()
type ChannelID = ()