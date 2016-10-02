{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module ClearingServer.Main where

import           Util
import           Util.Config (wrapArg)
import qualified ClearingServer.Config.Types as Conf

import qualified ClearingServer.Server.Issue as Issue
import qualified ClearingServer.Server.Callback as Callback

import qualified Network.Wai.Handler.Warp as Warp
import qualified Data.Configurator.Types as Configurator
import           Control.Concurrent (forkIO)
import           Data.Maybe (fromMaybe)


main :: IO ()
main = wrapArg $ \cfg _ -> do
    -- Start server
    runApp cfg

runApp :: Configurator.Config -> IO ()
runApp cfg = do
    --  Get port from PORT environment variable, if it contains a valid port number
    maybePort <- envReadPort
    appConf <- Conf.fromConf cfg
    --  Start callback handler app
    forkIO $ runLocalhost (Conf.getCallbackPort appConf) (Callback.serverApp appConf)
    --  Start issue/redeem app
    Warp.run (fromIntegral . fromMaybe 8081 $ maybePort) (Issue.serverApp appConf)
