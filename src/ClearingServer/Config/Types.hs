{-# LANGUAGE OverloadedStrings, TypeSynonymInstances, FlexibleInstances, DataKinds #-}

module ClearingServer.Config.Types where

import           ClearingServer.Config.Parse
import qualified Data.Configurator.Types as Configurator
import qualified Data.Tagged as Tag
import qualified Servant.Common.BaseUrl as BaseUrl



class FromConfig a where
    fromConfigurator :: Configurator.Config -> IO a

type ChanManagerConn = Tag.Tagged "ChanManager" BaseUrl.BaseUrl
type PayChanConn     = Tag.Tagged "PayChanServer" BaseUrl.BaseUrl


instance FromConfig ChanManagerConn where
    fromConfigurator = fmap Tag.Tagged .
        parseBaseUrl "payChanServer.management"

instance FromConfig PayChanConn where
    fromConfigurator = fmap Tag.Tagged .
        parseBaseUrl "payChanServer.payment"


data AppConf = AppConf
  { manageEndpoint      :: ChanManagerConn
  , paymentEndpoint     :: PayChanConn
  }

instance FromConfig AppConf where
    fromConfigurator cfg = AppConf <$>
        fromConfigurator cfg <*> fromConfigurator cfg
