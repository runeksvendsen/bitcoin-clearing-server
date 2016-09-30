{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}

module Util
(
    cs
  , (<>)
  , readerToEither
  , wrapArg
  , envReadPort
)
where

import           Types
import           Util.Config (wrapArg)
import           Data.String.Conversions (cs)
import           Data.Monoid ((<>))
import           Servant

import qualified Control.Monad.Reader as Reader

import           System.Environment (lookupEnv)
import           Text.Read (readMaybe)

-- |Transform an 'AppM conf' into a 'Servant.Handler'
readerToEither :: conf -> AppM conf :~> Handler
readerToEither cfg = Nat $ \x -> Reader.runReaderT x cfg

envReadPort :: IO (Maybe Word)
envReadPort = maybe Nothing readMaybe <$> lookupEnv "PORT"
