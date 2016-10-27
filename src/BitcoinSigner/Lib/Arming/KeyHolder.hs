module BitcoinSigner.Lib.Arming.KeyHolder where

import           Util
import           BitcoinSigner.Lib.Arming.Types
import qualified Control.Concurrent.MVar        as MV
import qualified Network.Haskoin.Crypto         as HC
import qualified Control.Concurrent             as Con


createEmptyKeyHolder :: IO KeyHolder
createEmptyKeyHolder  = MV.newEmptyMVar

waitForKey :: KeyHolder -> IO HC.XPrvKey
waitForKey h = MV.readMVar h >>=
    -- If Left, wait a second a try again
    -- When the "arming_done" request has been processed,
    --  the MVar will contain a Right, and this will return
    either (\_ -> logRecv >> Con.threadDelay (round 1e6) >> waitForKey h) return
    where logRecv = log_info "Waiting for finish request..."

putKeyInHolder :: HC.XPrvKey -> KeyHolder -> IO ()
putKeyInHolder = flip MV.putMVar . Left

-- |Signal, by changing from Left to Right, that we can safely kill the server
finishArm :: KeyHolder -> IO ()
finishArm h = Con.modifyMVar_ h switchToRight
    where switchToRight (Left privKey) = return $ Right privKey
          switchToRight (Right _) = error "Private key is already in Right for 'finishArm'"

