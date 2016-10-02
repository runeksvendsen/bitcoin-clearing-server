{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module ClearingServer.Server.Issue where

import           Types
import           Util
import qualified ClearingServer.API as API
import qualified ClearingServer.Config.Types as Conf

import           ClearingServer.Handlers.Order  (noteOrderHandler)
import           ClearingServer.Handlers.Redeem (noteRedemptionHandler)

import           Servant
import qualified Network.Wai as Wai


app :: ServerT API.Issue (AppM Conf.AppConf)
app = noteOrderHandler :<|> noteRedemptionHandler

api :: Proxy API.Issue
api = Proxy

serverApp :: Conf.AppConf -> Wai.Application
serverApp cfg = serve api $ serverEmbedConf app cfg
    where serverEmbedConf server cfg = enter (readerToEither cfg) server
