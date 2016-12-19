module BitcoinSigner.Lib.Arming.Handler.SignalDone where

import           BitcoinSigner.Lib.Arming.Types
import           BitcoinSigner.Lib.Arming.KeyHolder (finishArm)
import           Types
import           Util
import           Lib.Handler.Class (HasHandler(..))


instance IsPrivateKey k => HasHandler (Maybe String) ByteString (KeyHolder k) where
    handle = armingFinish

armingFinish :: IsPrivateKey k => Maybe String -> AppM (KeyHolder k) ByteString
armingFinish _ = do
    log_info' "Received arming finish-request."
    ask >>= liftIO . finishArm
    return "Success!"

