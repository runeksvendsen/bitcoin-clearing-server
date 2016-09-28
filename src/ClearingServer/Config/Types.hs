{-# LANGUAGE OverloadedStrings #-}

module ClearingServer.Config.Types where

import           ClearingServer.Types
import           ClearingServer.Config.Util
import           Data.Configurator.Types
import qualified Servant.Common.BaseUrl as BaseUrl

class FromConfig a where
    fromConf :: Config -> IO a


data PayChanServer = PayChanServer
  {  host       :: ByteString
  ,  mgmtPort   :: Word
  }

instance FromConfig PayChanServer where
    fromConf cfg = PayChanServer <$>
        configLookupOrFail cfg "payChanServer.management.host" <*>
        configLookupOrFail cfg "payChanServer.management.port"

