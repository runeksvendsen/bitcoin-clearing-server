{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module NoteStore.Server where

import           Types
import           PromissoryNote
import           Util
import qualified NoteStore.API as API
import           NoteStore.Types
import qualified Data.DiskMap as Disk
import           Servant
import qualified Control.Monad.Reader as R


storeApp :: ServerT API.Store AppStore
storeApp = getItem :<|> putItem :<|> delItem
    where
        getItem k   = R.ask >>= \m -> fetchItem m k
        putItem k v = R.ask >>= \m -> createItem m k v
        delItem     = error "STUB"

fetchItem :: Disk.DiskMap UUID PromissoryNote -> UUID -> AppStore PromissoryNote
fetchItem m k =
    R.liftIO (Disk.getItem m k) >>=
        \res -> case res of
            Just v  -> return v
            Nothing -> errorWithDescription 404 "Doesn't exist"


createItem :: Disk.DiskMap UUID PromissoryNote -> UUID -> PromissoryNote -> AppStore NoContent
createItem m k v =
    R.liftIO (Disk.addItem m k v) >>=
        \res -> case res of
            Disk.Created       -> return NoContent
            Disk.AlreadyExists -> errorWithDescription 400 "Already exists"