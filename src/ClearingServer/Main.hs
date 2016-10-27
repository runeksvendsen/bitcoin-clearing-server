{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module ClearingServer.Main where

import           Util
import           Util.Config (wrapArg)
import qualified ClearingServer.Config.Types as Conf

import qualified ClearingServer.Lib.App.Issue as Issue
import qualified ClearingServer.Lib.App.Callback as Callback

import qualified Network.Wai.Handler.Warp as Warp
import qualified Data.Configurator.Types as Configurator
import           Control.Concurrent (forkIO)


main :: IO ()
main = wrapArg runApp

runApp :: Configurator.Config -> String -> IO ()
runApp cfg _ = do
    --  Get port from PORT environment variable, if it contains a valid port number
    maybePort <- envReadPort
    appConf <- Conf.fromConf cfg
    --  Start callback handler app
    forkIO $ runLocalhost (Conf.getCallbackPort appConf) (Callback.serverApp appConf)
    --  Start issue/redeem app
    Warp.run (fromIntegral . fromMaybe 8081 $ maybePort) (Issue.serverApp appConf)
