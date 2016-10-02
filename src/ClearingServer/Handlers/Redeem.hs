module ClearingServer.Handlers.Redeem where

import Types
import PromissoryNote
import qualified ClearingServer.Config.Types as Conf


noteRedemptionHandler :: [PromissoryNote] -> AppM Conf.AppConf BitcoinTx
noteRedemptionHandler pnList =
    error "STUB"
