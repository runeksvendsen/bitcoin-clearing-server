module ClearingServer.Types.Data where

-- import           ClearingServer.Types
import qualified Data.Bitcoin.PaymentChannel.Types as BTC
import qualified Data.Bitcoin.PaymentChannel.Types as PayChan
import qualified Network.Haskoin.Transaction as HT
import qualified Data.ByteString as BS

data Hash a = Hash a
data SignatureOver a b = SigOver a b

data PubKeyHash =
    Sha256  BS.ByteString
  | Hash160 BS.ByteString   -- Bitcoin

data PubKey =
    PKSecp256k1 ()
  | PKEd25519   ()

type ChannelId  = HT.OutPoint
type Amount     = BTC.BitcoinAmount
-- Stubs
data ListOfLength len a = Stub2
type Identity = ()
type Signature = ()
type UTCTime = ()
data NonEmptyList a = Stub
type Currency = ()