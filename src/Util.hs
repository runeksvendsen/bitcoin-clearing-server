{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module Util
(
    module Util.Common
  , module Util.Hex
  , module Types
  , retry
  , Reader.ask, Reader.asks
  , readerToEither
  , envReadPort
  , errorWithDescription
  , runLocalhost
  , log_info, log_info'
  , log_warn, log_warn'
  , log_error, log_error'
)
where

import           Util.Hex
import           Util.Log
import           Util.Retry
import           Util.Common
import           Types
import           Servant

import qualified Control.Monad.Reader as Reader
import qualified Control.Monad.Error.Class as Except
import qualified Network.Wai as Wai
import qualified Network.Wai.Handler.Warp as Warp

import           System.Environment (lookupEnv)
import           Text.Read (readMaybe)

-- |Transform an 'AppM conf' into a 'Servant.Handler'
readerToEither :: conf -> AppM conf :~> Handler
readerToEither cfg = Nat $ \x -> Reader.runReaderT x cfg

envReadPort :: IO (Maybe Word)
envReadPort = maybe Nothing readMaybe <$> lookupEnv "PORT"

errorWithDescription :: Int -> String -> AppM conf a
errorWithDescription code e = Except.throwError $
    err400 { errReasonPhrase = cs e, errBody = cs e, errHTTPCode = code}

runLocalhost :: Word -> Wai.Application -> IO ()
runLocalhost port = Warp.runSettings settings
    where settings = Warp.setPort (fromIntegral port) $
                        Warp.setHost "127.0.0.1" Warp.defaultSettings
