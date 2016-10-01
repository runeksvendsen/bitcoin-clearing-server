module Store.Main where

import Store.Lib
import qualified Store.Config.Types as Conf
import qualified Network.Wai.Handler.Warp as Warp
import           Data.DiskMap (newDiskMap)
import           Util.Config (wrapArg)


main :: IO ()
main = wrapArg $ \cfg _ -> do
    appConf@(Conf.Conf dbDir _) <- Conf.fromConf cfg
    (map,_)     <- newDiskMap dbDir False
    --  Start app
    Warp.run (fromIntegral $ Conf.getPort appConf) (storeServerApp map)

