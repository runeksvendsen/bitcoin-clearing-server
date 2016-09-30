module ClearingServer.Handlers.Deliver where

import Types
import qualified ClearingServer.Config.Types as Conf
import RBPCP.Callback
import RBPCP.Callback.Types

valueReceivedHandler :: PaymentInfo -> AppM Conf.AppConf PaymentResponse
valueReceivedHandler = error "STUB"