module BitcoinSigner.Lib.Handler.Settle where

import           Util
import qualified BitcoinSigner.Lib.Config as Conf

import qualified Control.Monad.Reader as Reader
import qualified Util.Servant.Run     as Run


settleHandler :: RecvPayChanX -> AppM Conf.Config BitcoinTx
settleHandler chanState = do
    settleChannel <- asks Conf.settleChannel
    feeGetter     <- asks Conf.getZeroConfTxFee
    txFee         <- liftIO feeGetter
    return $ settleChannel chanState txFee


settleChan :: Conf.Config -> RecvPayChanX -> IO BitcoinTx
settleChan cfg chanState = Run.runHandler
    (Reader.runReaderT (settleHandler chanState) cfg) >>=
    either (\e -> log_error (errMsg e) >> error (errMsg e)) return
        where errMsg e = "settleChan error: " <> cs (show e)



