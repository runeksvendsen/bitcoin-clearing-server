{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}

module Util
(
    module Util.Hex
  , cs
  , (<>)
  , readerToEither
  , envReadPort
  , fmapL
  , errorWithDescription
)
where

import           Util.Hex
import           Types
import           Data.String.Conversions (cs)
import           Data.Monoid ((<>))
import           Servant
import           Data.EitherR (fmapL)

import qualified Control.Monad.Reader as Reader
import qualified Control.Monad.Error.Class as Except

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
