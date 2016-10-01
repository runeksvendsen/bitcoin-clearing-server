{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module ClearingServer.Main where

import           Types
import           Util
import           Util.Config (wrapArg)
import qualified ClearingServer.API as API
import qualified ClearingServer.Config.Types as Conf
import           ClearingServer.Handlers.Order   (issueOrderHandler)
import           ClearingServer.Handlers.Redeem  (noteRedemptionHandler)

import           Servant
import qualified Network.Wai as Wai
import qualified Network.Wai.Handler.Warp as Warp
import qualified Data.Configurator.Types as Configurator
import           Data.Maybe (fromMaybe)


clearingApp :: ServerT API.NoteAPI (AppM Conf.AppConf)
clearingApp = issueOrder :<|> redeemNotes
    where
        issueOrder     = issueOrderHandler
        redeemNotes    = noteRedemptionHandler

apiClearing :: Proxy API.NoteAPI
apiClearing = Proxy

clearingServerApp :: Conf.AppConf -> Wai.Application
clearingServerApp cfg = serve apiClearing $ serverEmbedConf clearingApp cfg
    where serverEmbedConf server cfg = enter (readerToEither cfg) server


main :: IO ()
main = wrapArg $ \cfg _ -> do
    -- Start server
    runApp cfg

runApp :: Configurator.Config -> IO ()
runApp cfg = do
    --  Get port from PORT environment variable, if it contains a valid port number
    maybePort <- envReadPort
    appConf <- Conf.fromConf cfg
    --  Start app
    Warp.run (fromIntegral . fromMaybe 8080 $ maybePort) (clearingServerApp appConf)
