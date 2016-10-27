module BitcoinSigner.Lib.Handler.Arming
(
    module BitcoinSigner.Lib.Handler.Arming
,   module BitcoinSigner.Lib.Arming.Types
)

where

import           BitcoinSigner.Lib.Arming.Types
import           BitcoinSigner.Lib.Arming.KeyHolder (putKeyInHolder)
import           Types
import           Util
import           Util.Crypto    (getFirstPubKey)


armingHandler :: ArmingPacket -> AppM KeyHolder ArmingResponse
armingHandler (ArmingPacket rootPrivKey) =
    log_info' "Received private key." >>
    -- Put key in holder, but signal (with a Left) to wait until "arming_done" request (where we put a Right)
    ask >>= liftIO . putKeyInHolder rootPrivKey >>
        return (ArmingResponse . getFirstPubKey $ rootPrivKey)
