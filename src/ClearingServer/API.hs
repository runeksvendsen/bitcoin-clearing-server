{-# LANGUAGE DataKinds, LambdaCase, TypeOperators, OverloadedStrings #-}

module ClearingServer.API
(
    NoteAPI
) where

import           ClearingServer.Types
import           PromissoryNote
import qualified Network.Haskoin.Transaction as HT
import           Servant.API



-- |The API exposed by this server
type NoteAPI =
          "issue"  :> "order"     :> ReqBody '[JSON] NoteOrder        :> Post '[JSON]  NoteInvoice
--     :<|>  "issue"  :> "deliver"   :> ReqBody '[JSON] NoteOrder        :> Get  '[JSON] [PromissoryNote]
    :<|>  "redeem"                :> ReqBody '[JSON] [PromissoryNote] :> Post '[JSON]  HT.Tx

