{-# LANGUAGE OverloadedStrings, TypeSynonymInstances, FlexibleInstances, DataKinds, MultiParamTypeClasses #-}

module ClearingServer.Config.Types
(
    module ClearingServer.Config.Types
)
where

import           Types.Config               (FromConfig(..))
import qualified NoteSigner.Interface     as Sign
import           Util.Config.Parse
import qualified Data.Tagged              as Tag
import qualified Servant.Common.BaseUrl   as BaseUrl

import           Util           (fromMaybe, envRead)
import           Servant.Server.Internal.Context


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
    fromConf _ = Tag.Tagged .
        fromMaybe (error "Missing CALLBACK_PORT env var.") <$>
        (envRead "CALLBACK_PORT")

getCallbackPort :: AppConf -> Word
getCallbackPort = Tag.untag . callbackPort



data AppConf = AppConf
  { manageEndpoint      :: ChanManagerConn
  , paymentEndpoint     :: PayChanConn
  , callbackPort        :: CallbackPort
  , signerIface         :: Sign.Interface
  }

instance FromConfig AppConf where
    fromConf cfg = AppConf <$>
        fromConf cfg <*>
        fromConf cfg <*>
        fromConf cfg <*>
        fromConf cfg


-- New style
type AppConf' = Context '[ChanManagerConn, PayChanConn, CallbackPort]

instance FromConfig AppConf' where
    fromConf cfg = do
        a <- fromConf cfg
        b <- fromConf cfg
        c <- fromConf cfg
        return $ a :. b :. c :. EmptyContext

