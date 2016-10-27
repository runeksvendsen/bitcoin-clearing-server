{-# LANGUAGE OverloadedStrings, TypeSynonymInstances, FlexibleInstances, DataKinds, MultiParamTypeClasses #-}

module ClearingServer.Config.Types
(
    module ClearingServer.Config.Types
--   , module Types.Config
)
where

-- import           Types
-- import           Types.Config
import           Util.Config
import           Util.Config.Parse
import qualified Data.Tagged as Tag
import qualified Servant.Common.BaseUrl as BaseUrl
import           Servant.Server.Internal.Context
import qualified Data.Configurator.Types as Configurator

class FromConfig a where
    fromConf :: Configurator.Config -> IO a

---
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
    fromConf cfg = Tag.Tagged <$> configLookupOrFail cfg "valueCallback.port"

getCallbackPort :: AppConf -> Word
getCallbackPort = Tag.untag . callbackPort


-- New style
type AppConf' = Context '[ChanManagerConn, PayChanConn, CallbackPort]

instance FromConfig AppConf' where
    fromConf cfg = do
        a <- fromConf cfg
        b <- fromConf cfg
        c <- fromConf cfg
        return $ a :. b :. c :. EmptyContext

-- Old style
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
