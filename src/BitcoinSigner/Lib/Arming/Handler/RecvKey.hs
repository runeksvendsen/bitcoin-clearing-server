module BitcoinSigner.Lib.Arming.Handler.RecvKey
(
    module BitcoinSigner.Lib.Arming.Handler.RecvKey
,   module BitcoinSigner.Lib.Arming.Types
)

where

import           BitcoinSigner.Lib.Arming.Types
import           BitcoinSigner.Lib.Arming.KeyHolder (putKeyInHolder)
import           Types
import           Util
import           Lib.Handler.Class (HasHandler(..))


instance IsPrivateKey k => HasHandler (ArmingPacket k) (ArmingResponse k) (KeyHolder k) where
    handle = armingHandler

armingHandler :: IsPrivateKey k => ArmingPacket k -> AppM (KeyHolder k) (ArmingResponse k)
armingHandler (ArmingPacket rootPrivKey) =
    log_info' "Received private key." >>
    -- Put key in holder, but signal (with a Left) to wait
    --  until "arming_done" request (where we put a Right)
    ask >>= liftIO . putKeyInHolder rootPrivKey >>
        return (ArmingResponse . getHash $ rootPrivKey)
