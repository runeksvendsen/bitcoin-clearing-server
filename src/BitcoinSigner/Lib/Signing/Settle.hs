module BitcoinSigner.Lib.Signing.Settle
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
--   script (client+server pubkey) to just the server's pubkey (address).
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
    destAddr <*> signFunc <*> pure fee
  where signFunc = flip HC.signMsg <$> Crypto.prvKeyCFromIndexM keyIndex
        keyIndex = Pay.rpcMetadata rpc
        destAddr = HC.xPubAddr <$> pubKeyCheckGet keyIndex (Pay.getReceiverPubKey rpc)

pubKeyCheckGet :: HC.KeyIndex -> Pay.RecvPubKey -> Crypto.KeyBox HC.XPubKey
pubKeyCheckGet keyIndex statePub =
    Crypto.xPubFromIndexM keyIndex >>=
    \xpub -> if pubKeysMatch xpub then return xpub else
        fail $ "settleChanM: pubkey non-match: " ++
            show (keyIndex, Pay.getPubKey statePub, xpub)
    where pubKeysMatch xpub = HC.xPubKey xpub == Pay.getPubKey statePub
