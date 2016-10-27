module BitcoinSigner.Lib.Arming.Server where

import           BitcoinSigner.Lib.Arming.KeyHolder
import qualified BitcoinSigner.Lib.App.Boot     as Boot
import qualified BitcoinSigner.Lib.Config       as Conf
import qualified Control.Concurrent             as Con
import qualified Network.Haskoin.Crypto         as HC
import qualified Network.Wai.Handler.Warp       as Warp



spawnArmingServer :: IO HC.XPrvKey
spawnArmingServer = do
    keyHolder <- createEmptyKeyHolder
    putStrLn $ "Arming server: Listening on port " ++ show Conf.port
    armingSrvrId <- Con.forkIO $ Warp.run (fromIntegral Conf.port) (Boot.armingApp keyHolder)
    rootPrvKey <- waitForKey keyHolder
    Con.killThread armingSrvrId
    return rootPrvKey


