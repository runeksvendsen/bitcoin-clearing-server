module ClearingServer.Config.Util where

import           Util
import qualified Data.Configurator as Conf
import           Data.Configurator.Types

configLookupOrFail :: Configured a => Config -> Name -> IO a
configLookupOrFail conf name =
    Conf.lookup conf name >>= maybe
        (fail $ "ERROR: Failed to read key \"" ++ cs name ++
            "\" in config (key not present or invalid)")
        return

