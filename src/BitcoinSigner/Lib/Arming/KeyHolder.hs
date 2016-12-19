module BitcoinSigner.Lib.Arming.KeyHolder where

import           Util
import           BitcoinSigner.Lib.Arming.Types
import qualified Control.Concurrent.MVar        as MV


createEmptyKeyHolder :: IsPrivateKey k => IO (KeyHolder k)
createEmptyKeyHolder  = MV.newEmptyMVar

-- |The server main thread will wait for the key.
waitForKey :: IsPrivateKey k => KeyHolder k -> IO k
waitForKey h = MV.takeMVar h >>=
    -- When we read a "Right key", the sender has given us the key.
    either (const $ logWarn >> waitForKey h) (\k -> logRecv >> waitWithKey k)
  where
    -- When we read something next, the sender has come back to signal we're done.
    waitWithKey prvKey = MV.takeMVar h >>= const (return prvKey)
    logRecv = log_info "Received private key. Waiting for finish request..."
    logWarn = log_warn "Received 'Left ()' before receiving private key"

-- |While the arming server handler will put the received key in the holder.
putKeyInHolder :: IsPrivateKey k => k -> KeyHolder k -> IO ()
putKeyInHolder = flip MV.putMVar . Right

-- |Signal to the main thread that we can safely kill the arming server
finishArm :: IsPrivateKey k => KeyHolder k -> IO ()
finishArm h = MV.putMVar h $ Left ()


