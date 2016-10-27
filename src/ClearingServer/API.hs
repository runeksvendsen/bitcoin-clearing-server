{-# LANGUAGE DataKinds, LambdaCase, TypeOperators, OverloadedStrings #-}

module ClearingServer.API
(
    Issue
  , Callback
) where

import           ClearingServer.Lib.Types
import           PromissoryNote
import qualified Network.Haskoin.Transaction as HT
import           Servant.API
import qualified RBPCP.Callback as CB


-- |The API exposed by this server
type Issue =
          "issue"  :> "order"     :> ReqBody '[JSON]  NoteOrder       :> Post '[JSON] NoteInvoice
    :<|>  "redeem"                :> ReqBody '[JSON] [PromissoryNote] :> Post '[JSON] HT.Tx
    -- Internal

type Callback = CB.PaymentCallback
