{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}
module NoteSigner.Types.Error where

import qualified Data.Serialize as Bin
import GHC.Generics



data SigningError =
    InternalError String
        deriving (Show, Eq, Generic, Bin.Serialize)

