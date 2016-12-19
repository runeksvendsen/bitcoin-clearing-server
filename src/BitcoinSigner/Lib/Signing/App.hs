{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module BitcoinSigner.Lib.Signing.App where

import           Types
import           Util

import           BitcoinSigner.Lib.Signing.Handler.Pubkey ()
import           BitcoinSigner.Lib.Signing.Handler.Redeem ()
import           BitcoinSigner.Lib.Signing.Handler.Settle ()

import qualified BitcoinSigner.Lib.Signing.API      as API
import qualified BitcoinSigner.Lib.Signing.Config           as Conf
import           BitcoinSigner.Lib.Signing.Orphans ()

import           Lib.Handler.Class          (handle)
import           Servant
import qualified Network.Wai as Wai


app :: ServerT API.BTCSign (AppM Conf.Config)
app = handle :<|> handle :<|> handle

api :: Proxy API.BTCSign
api = Proxy

cryptoApp :: Conf.Config -> Wai.Application
cryptoApp conf = serve api $ serverEmbedConf app conf
    where serverEmbedConf server cfg = enter (readerToEither cfg) server
