{-# LANGUAGE OverloadedStrings #-}

module ClearingServer.Config.Parse where

import           Types
import           ClearingServer.Config.Orphans ()
import           Util
import           ClearingServer.Config.Util
import           Data.Configurator.Types
import qualified Servant.Common.BaseUrl as BaseUrl

parseBaseUrl :: Text -> Config -> IO BaseUrl.BaseUrl
parseBaseUrl keyPrefix cfg = BaseUrl.BaseUrl <$>
    configLookupOrFail cfg (keyPrefix <> "protocol") <*>
    configLookupOrFail cfg (keyPrefix <> "host") <*>
    configLookupOrFail cfg (keyPrefix <> "port") <*>
    return ""   -- path prefix

