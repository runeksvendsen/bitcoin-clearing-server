module Util.KeyBox
(   Interface(..)
,   mkInterface
)where
import qualified Data.Bitcoin.PaymentChannel        as Pay
import qualified Data.Bitcoin.PaymentChannel.Types  as Pay
import qualified Network.Haskoin.Transaction        as HT
import qualified Network.Haskoin.Crypto             as HC
import qualified Data.Word                          as Word
import qualified Control.Monad.Reader               as Reader


data Interface = Interface
   { pubKeyByIndex  :: Word.Word32 -> HC.XPubKey
   , claimChanFunds :: Pay.ReceiverPaymentChannelX -> Pay.BitcoinAmount -> HT.Tx
   }

mkInterface :: HC.XPrvKey -> Interface
mkInterface rootPrv = Interface
    (getXPubKey rootPrv)
    (claimChanFunds' rootPrv)



getXPubKey :: HC.XPrvKey -> Word.Word32 -> HC.XPubKey
getXPubKey rootPrvKey = runSignM rootPrvKey . getXPubKeyM

-- |Produce a transaction that moves the received funds from the channel
--   script (client+server pubkey) to the server's pubkey only.
claimChanFunds' :: HC.XPrvKey
               -> Pay.ReceiverPaymentChannelX   -- ^ Receiver state object
               -> Pay.BitcoinAmount             -- ^ Bitcoin transaction fee
               -> HT.Tx                         -- ^ Bitcoin transaction
claimChanFunds' rootPrvKey rpc =
    runSignM rootPrvKey . claimChanFundsM rpc

type KeyBox = Reader.Reader HC.XPrvKey

runSignM :: HC.XPrvKey -> KeyBox a -> a
runSignM = flip Reader.runReader



-- |Produce a transaction that moves the received funds from the channel
--   script (client+server pubkey) to the server's pubkey only.
claimChanFundsM :: Pay.ReceiverPaymentChannelX   -- ^ Receiver state object
                -> Pay.BitcoinAmount             -- ^ Bitcoin transaction fee
                -> KeyBox HT.Tx                  -- ^ Bitcoin transaction
claimChanFundsM rpc fee = Pay.getSettlementBitcoinTx rpc <$>
    signFunc <*> pure destAddr <*> pure fee
  where signFunc = flip HC.signMsg <$> getPrvKey (Pay.rpcGetXPub rpc)
        destAddr = HC.xPubAddr (Pay.rpcGetXPub rpc)

getXPubKeyM :: Word.Word32 -> KeyBox HC.XPubKey
getXPubKeyM i = snd <$> getKeyPair i

getPrvKey :: HC.XPubKey -> KeyBox HC.PrvKeyC
getPrvKey xpub = prvKeyByIndex (HC.xPubIndex xpub)

prvKeyByIndex :: Word.Word32 -> KeyBox HC.PrvKeyC
prvKeyByIndex i = fst <$> getKeyPair i

getKeyPair :: Word.Word32 -> KeyBox (HC.PrvKeyC, HC.XPubKey)
getKeyPair i = do
    rootPrvKey <- Reader.ask
    let hardSubKey = HC.hardSubKey rootPrvKey i
    let mkKeyPair k = return (HC.xPrvKey k, HC.deriveXPubKey k)
    mkKeyPair hardSubKey
