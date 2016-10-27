{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module ClearingServer.Lib.App.Callback where

import           Types
import           Util
import qualified ClearingServer.API as API
import qualified ClearingServer.Config.Types as Conf

import           ClearingServer.Handlers.Callback.ValueRecv  (valueReceivedHandler)

import           Servant
import qualified Network.Wai as Wai


app :: ServerT API.Callback (AppM Conf.AppConf)
app = valueReceivedHandler

api :: Proxy API.Callback
api = Proxy

serverApp :: Conf.AppConf -> Wai.Application
serverApp cfg = serve api $ serverEmbedConf app cfg
    where serverEmbedConf server cfg = enter (readerToEither cfg) server
