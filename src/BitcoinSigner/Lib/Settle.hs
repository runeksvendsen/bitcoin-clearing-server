module BitcoinSigner.Lib.Settle
(
settleChan
)

where

import qualified Util.Crypto                        as Crypto
import qualified Network.Haskoin.Crypto             as HC
import qualified Data.Bitcoin.PaymentChannel        as Pay
import qualified Data.Bitcoin.PaymentChannel.Types  as Pay
import qualified Network.Haskoin.Transaction        as HT


-- |Produce a transaction that moves the received funds from the channel
--   script (client+server pubkey) to the server's pubkey only.
settleChan :: HC.XPrvKey
           -> Pay.ReceiverPaymentChannelX   -- ^ Receiver state object
           -> Pay.SatoshisPerByte             -- ^ Bitcoin transaction fee
           -> HT.Tx                         -- ^ Bitcoin transaction
settleChan rootPrvKey rpc =
    Crypto.runSignM rootPrvKey . settleChanM rpc

settleChanM :: Pay.ReceiverPaymentChannelX   -- ^ Receiver state object
            -> Pay.SatoshisPerByte          -- ^ Bitcoin transaction fee
            -> Crypto.KeyBox HT.Tx                  -- ^ Bitcoin transaction
settleChanM rpc fee = Pay.getSettlementBitcoinTx rpc <$>
    pure destAddr <*> signFunc <*> pure fee
  where signFunc = flip HC.signMsg <$> Crypto.prvKeyFromPubM (Pay.rpcGetXPub rpc)
        destAddr = HC.xPubAddr (Pay.rpcGetXPub rpc)

