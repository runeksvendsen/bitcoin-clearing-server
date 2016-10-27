module BitcoinSigner.Lib.Arming.Test where

import           Util
import           Util.Retry                               (retryTimesWithDelay)
import           Util.Crypto                              (getFirstPubKey)
import           Util.Bitcoin.Wallet.Keys                 (indexZeroPubKey)
import qualified Util.Bitcoin.Wallet.Interface     as Wallet
import qualified Network.Haskoin.Crypto                 as HC


-- |Confirm that the wallet server, who only receives a public key,
--  agrees with the keys we derive using the private key. Do this by
--  comparing the key at index 0.
testPubKeyDerivationWorks :: HC.XPrvKey -> Wallet.Interface -> IO Bool
testPubKeyDerivationWorks rootPrv iface = retryTimesWithDelay "testPubKeyDerivation" 100 100000 $    -- Retry up to 100 times with a delay of 1e5 microseconds (that's 0.1 second)
    (indexZeroPubKey <$> Wallet.listKeys iface) >>=
        maybe (error "PubKeyC at index 0 not found in response from wallet") checkPubKey
    where
        checkPubKey walletPubKey0
            | walletPubKey0 /= getFirstPubKey rootPrv =
                log_error "Public key derivation broken" >> return False
            | otherwise = log_info "Public key derivation works" >> return True

