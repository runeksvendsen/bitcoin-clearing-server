{-# LANGUAGE DataKinds, LambdaCase, TypeOperators, OverloadedStrings #-}

module ClearingServer.API
(
    Api
) where

import           ClearingServer.Types
import           ClearingServer.Types.Data
import           ClearingServer.Types.Response
import           PromissoryNote.Types
import qualified Network.Haskoin.Transaction as HT
import           Servant.API



-- |The API exposed by this server
type Api =
            "info"                                                      :> Get  '[JSON] ServerInfo
    :<|>    "issue"  :> "get_fee"   :> Capture "client_pubkey" PubKey   :> Get  '[JSON] ClientFeeInfo
    :<|>    "issue"  :> "order"     :> ReqBody '[JSON] NoteOrder        :> Post '[JSON] NoteInvoice
    :<|>    "issue"  :> "deliver"   :> ReqBody '[JSON] NoteOrder        :> Get  '[JSON] PromissoryNote
    :<|>    "redeem"                :> ReqBody '[JSON] [PromissoryNote] :> Post '[JSON] HT.Tx

