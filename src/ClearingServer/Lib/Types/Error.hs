{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}
module ClearingServer.Lib.Types.Error where

import GHC.Generics
import Data.Aeson (FromJSON, ToJSON)


data ClearSrvError =
    ParseFailure String
  | InternalError String
        deriving (Show, Eq, Generic, ToJSON, FromJSON)

