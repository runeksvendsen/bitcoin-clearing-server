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
          "redeem"      :> ReqBody '[JSON] [RedeemBlock]    :> Post '[JSON] HT.Tx
    :<|>  "solvency"                                        :> Get '[JSON]  Int


type Callback = CB.PaymentCallback
