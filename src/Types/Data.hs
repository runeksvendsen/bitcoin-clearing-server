module Types.Data where

import qualified Data.Bitcoin.PaymentChannel.Types as BTC
import qualified Data.Bitcoin.PaymentChannel.Types as PayChan
import qualified Network.Haskoin.Transaction as HT

data PubKey =
    PKSecp256k1 ()
  | PKEd25519   ()

type ChannelId  = HT.OutPoint
type Amount     = BTC.BitcoinAmount
-- Stubs
type Identity = ()
type Signature = ()
type UTCTime = ()
