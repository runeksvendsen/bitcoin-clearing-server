module BitcoinSigner.Lib.Handler.Redeem where

import Types
import PromissoryNote (RedeemBlock)
import qualified BitcoinSigner.Lib.Config as Conf


redeemHandler :: RedeemBlock -> AppM Conf.Config BitcoinTx
redeemHandler rb =
    error "STUB"
