{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module BitcoinSigner.Lib.App.Crypto where

import           Types
import           Util
-- import qualified BitcoinSigner.Lib.Arming.Types           as Arm
import qualified BitcoinSigner.API.Crypto           as API
import qualified BitcoinSigner.Lib.Config           as Conf
import           BitcoinSigner.Lib.Handler.Class          (handle)
import           BitcoinSigner.Lib.Orphans ()

import           Servant
import qualified Network.Wai as Wai


app :: ServerT API.BTCSign (AppM Conf.Config)
app = handle :<|> handle :<|> handle

api :: Proxy API.BTCSign
api = Proxy

cryptoApp :: Conf.Config -> Wai.Application
cryptoApp cfg = serve api $ serverEmbedConf app cfg
    where serverEmbedConf server cfg = enter (readerToEither cfg) server
