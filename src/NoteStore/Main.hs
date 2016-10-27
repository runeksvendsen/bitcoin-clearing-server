module NoteStore.Main where

import           NoteStore.Lib
import qualified NoteStore.Config.Types as Conf
import qualified Network.Wai.Handler.Warp as Warp
import           Data.DiskMap (newDiskMap)
import           Util.Config (wrapArg)


main :: IO ()
main = wrapArg $ \cfg _ -> do
    appConf@(Conf.Conf dbDir _) <- Conf.fromConf cfg
    map <- newDiskMap dbDir
    --  Start app
    Warp.run (fromIntegral $ Conf.getPort appConf) (storeServerApp map)

