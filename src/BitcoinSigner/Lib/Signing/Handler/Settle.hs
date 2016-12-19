module BitcoinSigner.Lib.Signing.Handler.Settle where

import           Util
import qualified BitcoinSigner.Lib.Signing.Config   as Conf
import qualified Control.Monad.Reader               as Reader
import qualified Util.Servant.Run                   as Run
import           Lib.Handler.Class (HasHandler(..))


instance HasHandler RecvPayChanX BitcoinTx Conf.Config where
    handle = settleHandler

settleHandler :: RecvPayChanX -> AppM Conf.Config BitcoinTx
settleHandler chanState = do
    settleChannel <- asks Conf.settleChannel
    feeGetter     <- asks Conf.getZeroConfTxFee
    txFee         <- liftIO feeGetter
    pushTx        <- asks Conf.pushTx
    let tx = settleChannel chanState txFee
    log_info' $ "Publishing tx: " <> tshow tx
    liftIO $ print =<< pushTx tx
    return tx

settleChan :: Conf.Config -> RecvPayChanX -> IO BitcoinTx
settleChan cfg chanState = Run.runHandler
    (Reader.runReaderT (settleHandler chanState) cfg) >>=
    either (\e -> log_error (errMsg e) >> error (errMsg e)) return
        where errMsg e = "settleChan error: " <> cs (show e)



