{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module BitcoinSigner.Lib.App.Boot where

import           Types
import           Util
import           BitcoinSigner.Lib.Arming.Types (KeyHolder)
import qualified BitcoinSigner.API.Boot       as API
import           BitcoinSigner.Lib.Handler.Class    (handle)
import           BitcoinSigner.Lib.Orphans ()

import           Servant
import qualified Network.Wai as Wai


app :: ServerT API.Boot (AppM KeyHolder)
app = handle :<|> handle

armingApp :: KeyHolder -> Wai.Application
armingApp holder = serve api $ serverEmbedConf app holder
    where
        serverEmbedConf server h = enter (readerToEither h) server
        api :: Proxy API.Boot
        api = Proxy

