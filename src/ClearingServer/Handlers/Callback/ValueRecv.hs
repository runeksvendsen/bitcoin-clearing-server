module ClearingServer.Handlers.Callback.ValueRecv where

import Types
import qualified ClearingServer.Config.Types as Conf
import RBPCP.Callback


valueReceivedHandler :: PaymentInfo -> AppM Conf.AppConf PaymentResponse
valueReceivedHandler (PaymentInfo paymentValue chanValLeft) =
    error "STUB"