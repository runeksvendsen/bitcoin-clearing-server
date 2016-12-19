module BitcoinSigner.Lib.Signing.Handler.Redeem where

import Types
import PromissoryNote (RedeemBlock)
import qualified BitcoinSigner.Lib.Signing.Config as Conf
import Lib.Handler.Class (HasHandler(..))


instance HasHandler RedeemBlock BitcoinTx Conf.Config where
    handle = redeemHandler

redeemHandler :: RedeemBlock -> AppM Conf.Config BitcoinTx
redeemHandler rb =
    error "STUB"

