module BitcoinSigner.Lib.Handler.ArmingDone where

import           BitcoinSigner.Lib.Arming.Types
import           BitcoinSigner.Lib.Arming.KeyHolder (finishArm)
import           Types
import           Util


armingFinish :: Maybe String -> AppM KeyHolder ByteString
armingFinish _ =
    log_info' "Received arming finish-request." >>
    ask >>=
    \kh -> liftIO (finishArm kh) >> return "Success!"

