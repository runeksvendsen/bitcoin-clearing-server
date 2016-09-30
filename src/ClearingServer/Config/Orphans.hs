{-# LANGUAGE OverloadedStrings #-}

module ClearingServer.Config.Orphans where

import           Data.Configurator.Types
import qualified Servant.Common.BaseUrl as BaseUrl

instance Configured BaseUrl.Scheme where
    convert (String "http") = return BaseUrl.Http
    convert (String "https") = return BaseUrl.Https
    convert _ = Nothing