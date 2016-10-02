{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module Store.Lib where

import           Types
import qualified Store.API as API
import           Store.Server
import           Store.Types ()
import           PromissoryNote
import           Util
import           Data.DiskMap (DiskMap)
import           Servant
import qualified Network.Wai as Wai


apiStore :: Proxy API.Store
apiStore = Proxy

storeServerApp :: DiskMap UUID PromissoryNote -> Wai.Application
storeServerApp map = serve apiStore $ serverEmbedConf storeApp map
    where serverEmbedConf server map = enter (readerToEither map) server

