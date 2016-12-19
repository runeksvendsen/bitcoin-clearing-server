{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module NoteSigner.App where

import           Types
import           Util
import qualified NoteSigner.API                 as API
import qualified NoteSigner.Config              as Conf
import           NoteSigner.Handler.SignNote      ()
import           NoteSigner.Handler.CheckReady    (checkReady)
import           Lib.Handler.Class                (handle)

import           Servant
import qualified Network.Wai as Wai


app :: ServerT API.NoteSigner (AppM Conf.Config)
app = handle :<|> checkReady

noteSigner :: Conf.Config -> Wai.Application
noteSigner map = serve api $ serverEmbedConf app map
    where
        serverEmbedConf server h = enter (readerToEither h) server
        api :: Proxy API.NoteSigner
        api = Proxy

