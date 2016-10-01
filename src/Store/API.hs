{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}

module Store.API where

import           Types
import           Store.Types ()
import           PromissoryNote
import           Servant


type PN = PromissoryNote

type API =
        "store" :> Capture "key" UUID :> "get"     :>                               Get  '[OctetStream] PN
  :<|>  "store" :> Capture "key" UUID :> "put"     :>  ReqBody '[OctetStream] PN :> Post '[OctetStream] NoContent
  :<|>  "store" :> Capture "key" UUID :> "delete"  :>                               Put  '[OctetStream] NoContent

