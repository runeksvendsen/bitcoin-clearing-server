module Util.Crypto where

import qualified Network.Haskoin.Crypto             as HC
import           Network.Haskoin.Crypto               (DerivPathI(..))
import qualified Network.Haskoin.Wallet             as Wallet
import qualified Data.Word                          as Word
import qualified Control.Monad.Reader               as Reader


getRootXPubKey = HC.deriveXPubKey

defaultPath :: HC.SoftPath
defaultPath = Deriv :/ Wallet.addrTypeIndex Wallet.AddressExternal

prvKeyFromPubM :: HC.XPubKey -> KeyBox HC.PrvKeyC
prvKeyFromPubM xPub = flip prvKeyFromXPub xPub <$> Reader.ask

prvKeyFromXPub :: HC.XPrvKey -> HC.XPubKey -> HC.PrvKeyC
prvKeyFromXPub rootPrv xpub = HC.xPrvKey $ subKeyPrv rootPrv i
    where i = HC.xPubIndex xpub

subKeyPubC :: HC.XPrvKey -> Word.Word32 -> HC.PubKeyC
subKeyPubC prv = HC.xPubKey . subKeyPub (HC.deriveXPubKey prv)

subKeyPub :: HC.XPubKey -> Word.Word32 -> HC.XPubKey
subKeyPub rootPub = HC.pubSubKey xPubKey
    where
        xPubKey = HC.derivePubPath defaultPath rootPub

subKeyPrv :: HC.XPrvKey -> Word.Word32 -> HC.XPrvKey
subKeyPrv rootPrvKey = HC.prvSubKey xPrvKey
    where
        xPrvKey = HC.derivePath defaultPath rootPrvKey


getFirstPubKey :: HC.XPrvKey -> HC.PubKeyC
getFirstPubKey = HC.xPubKey . flip subKeyPub 0 . HC.deriveXPubKey


runSignM :: HC.XPrvKey -> KeyBox a -> a
runSignM = flip Reader.runReader

type KeyBox = Reader.Reader HC.XPrvKey










type Signature = ()