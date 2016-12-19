{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module BitcoinSigner.Lib.Arming.App where

import           Types
import           Util
import           BitcoinSigner.Lib.Arming.Types (KeyHolder, IsPrivateKey)
import qualified BitcoinSigner.Lib.Arming.API       as API
import           Lib.Handler.Class    (handle)
import           BitcoinSigner.Lib.Arming.Handler.RecvKey ()
import           BitcoinSigner.Lib.Arming.Handler.SignalDone ()

import           Servant
import qualified Network.Wai as Wai


app :: IsPrivateKey k => ServerT (API.Boot k) (AppM (KeyHolder k))
app = handle :<|> handle

armingApp :: IsPrivateKey k => KeyHolder k -> Wai.Application
armingApp holder = serve api $ serverEmbedConf app holder
    where
        serverEmbedConf server h = enter (readerToEither h) server
        api :: Proxy (API.Boot k)
        api = Proxy

