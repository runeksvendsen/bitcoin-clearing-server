module ClearingServer.Handlers.Callback.ValueRecv where

import Types
import qualified ClearingServer.Config.Types as Conf
import RBPCP.Callback


valueReceivedHandler :: PaymentInfo -> AppM Conf.AppConf PaymentResponse
valueReceivedHandler (PaymentInfo amount senderPK chanValueLeft chanTotalValue) =
    return $ PaymentResponse "hello world"
