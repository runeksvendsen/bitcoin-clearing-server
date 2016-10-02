{-# LANGUAGE OverloadedStrings, TypeSynonymInstances, FlexibleInstances, DataKinds #-}

module ClearingServer.Config.Types
(
    module ClearingServer.Config.Types
  , module Types.Config
)
where

import           Types
import           Types.Config
import           Util.Config
import           Util.Config.Parse
import qualified Data.Tagged as Tag
import qualified Servant.Common.BaseUrl as BaseUrl

data ChanManager
type ChanManagerConn = Tag.Tagged ChanManager BaseUrl.BaseUrl
instance FromConfig ChanManagerConn where
    fromConf = parseTaggedBaseUrl "payChanServer.management"

data PayChanServer
type PayChanConn = Tag.Tagged PayChanServer BaseUrl.BaseUrl
instance FromConfig PayChanConn where
    fromConf = parseTaggedBaseUrl "payChanServer.payment"

type CallbackPort = Tag.Tagged "CBPort" Word
instance FromConfig CallbackPort where
    fromConf cfg = fmap Tag.Tagged $ configLookupOrFail cfg "valueCallback.port"


data AppConf = AppConf
  { manageEndpoint      :: ChanManagerConn
  , paymentEndpoint     :: PayChanConn
  , callbackPort        :: CallbackPort
  }

instance FromConfig AppConf where
    fromConf cfg = AppConf <$>
        fromConf cfg <*>
        fromConf cfg <*>
        fromConf cfg

getCallbackPort :: AppConf -> Word
getCallbackPort = Tag.untag . callbackPort
