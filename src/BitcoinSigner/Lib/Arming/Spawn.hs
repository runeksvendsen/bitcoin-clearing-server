module BitcoinSigner.Lib.Arming.Spawn where

import           BitcoinSigner.Lib.Arming.Types
import           BitcoinSigner.Lib.Arming.KeyHolder
import qualified BitcoinSigner.Lib.Arming.App       as App
import qualified BitcoinSigner.Lib.Arming.Constants as C

import qualified Control.Concurrent                 as Con
import qualified Network.Wai.Handler.Warp           as Warp



spawnArmingServer :: IsPrivateKey k => IO k
spawnArmingServer = do
    keyHolder <- createEmptyKeyHolder
    armingSrvrId <- Con.forkIO $ Warp.run (fromIntegral C.port) (App.armingApp keyHolder)
    putStrLn $ "Arming server: Listening on port " ++ show C.port
    -- Wait for arming server to receive key in request, and put it in keyHolder
    rootPrvKey <- waitForKey keyHolder
    Con.killThread armingSrvrId
    return rootPrvKey


