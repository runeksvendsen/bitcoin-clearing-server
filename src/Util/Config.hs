module Util.Config
(
    wrapArg
)
 where

import qualified Data.Configurator.Types as Configurator
import           System.Environment (getArgs, getProgName)
import qualified Data.Configurator as Conf

loadConfig :: String -> IO Configurator.Config
loadConfig confFile = Conf.load [Conf.Required confFile]

wrapArg :: (Configurator.Config -> String -> IO ()) -> IO ()
wrapArg main' = do
    args <- getArgs
    prog <- getProgName
    if  length args < 1 then
            putStrLn $ "Usage: " ++ prog ++ " /path/to/config.cfg"
        else do
            let cfgFile = head args
            putStrLn $ "Using config file " ++ show cfgFile
            cfg <- loadConfig cfgFile
            main' cfg cfgFile