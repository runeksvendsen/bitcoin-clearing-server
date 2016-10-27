{-# LANGUAGE OverloadedStrings #-}
module NoteStore.Config.Types
(
    module NoteStore.Config.Types
  , module Types.Config
)
 where

import           Types
import           Types.Config
import           Util.Config
import           Util.Config.Parse
import qualified Servant.Common.BaseUrl as BaseUrl

data Conf = Conf
  { dbDirectory     :: String
  , endPoint        :: BaseUrl.BaseUrl
  }

instance FromConfig Conf where
    fromConf cfg = Conf <$>
        configLookupOrFail cfg "directory" <*>
        parseBaseUrl "network" cfg

getPort :: Conf -> Int
getPort = BaseUrl.baseUrlPort . endPoint
