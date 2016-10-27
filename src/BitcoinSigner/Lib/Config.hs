module BitcoinSigner.Lib.Config where

import qualified Util.Bitcoin.Wallet.Interface      as Wallet
import qualified BitcoinSigner.Lib.KeyCounter       as Key
import qualified Data.Bitcoin.PaymentChannel.Types  as Pay
import qualified Network.Haskoin.Transaction        as HT

port :: Word
port = 8080

data Config = Config
  { wallet              :: Wallet.Interface
  , settleChannel       :: Pay.ReceiverPaymentChannelX -> Pay.SatoshisPerByte -> HT.Tx
  , getZeroConfTxFee    :: IO Pay.SatoshisPerByte
  , keyBox     :: Key.KeyCounter
  }

