module BitcoinSigner.Lib.Signing.Config where

import           Util
import qualified Util.Bitcoin.Wallet.Interface      as Wallet
import qualified BitcoinSigner.Lib.Signing.KeyCounter       as Key
import qualified Data.Bitcoin.PaymentChannel.Types  as Pay
import qualified Network.Haskoin.Transaction        as HT
import qualified Network.Haskoin.Crypto             as HC
import           Network.Haskoin.Wallet               (JsonTx)
import           Util.Crypto                          (getRootXPubKey)
import           BitcoinSigner.Lib.Signing.Settle             (settleChan)
import           Util.Bitcoin.Fee                     (getBestFee)


port :: Word
port = 8080


data Config = Config
  { wallet              :: Wallet.Interface
  , settleChannel       :: Pay.ReceiverPaymentChannelX -> Pay.SatoshisPerByte -> HT.Tx
  , getZeroConfTxFee    :: IO Pay.SatoshisPerByte
  , keyBox              :: Key.KeyCounter
  , pushTx              :: HT.Tx -> IO JsonTx
  }

buildConf :: HC.XPrvKey -> Wallet.Interface -> IO Config
buildConf rootPrvKey iface = do
    keyCounter <- Key.newCounter (getRootXPubKey rootPrvKey)
    return $ Config iface (settleChan rootPrvKey) getBestFee keyCounter
        (Wallet.importTx iface)
