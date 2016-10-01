{-# LANGUAGE OverloadedStrings, TypeSynonymInstances, FlexibleInstances, DataKinds #-}

module ClearingServer.Config.Types
(
    module ClearingServer.Config.Types
  , module Types.Config
)
where

import           Types
import           Types.Config
import           Util.Config.Parse
import qualified Data.Tagged as Tag
import qualified Servant.Common.BaseUrl as BaseUrl


instance FromConfig ChanManagerConn where
    fromConf = parseTaggedBaseUrl "payChanServer.management"

instance FromConfig PayChanConn where
    fromConf = parseTaggedBaseUrl "payChanServer.payment"

data ChanManager
data PayChanServer
type ChanManagerConn = Tag.Tagged ChanManager BaseUrl.BaseUrl
type PayChanConn     = Tag.Tagged PayChanServer BaseUrl.BaseUrl

data AppConf = AppConf
  { manageEndpoint      :: ChanManagerConn
  , paymentEndpoint     :: PayChanConn
  }

instance FromConfig AppConf where
    fromConf cfg = AppConf <$>
        fromConf cfg <*>
        fromConf cfg
