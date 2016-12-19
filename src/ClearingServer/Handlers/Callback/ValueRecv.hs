module ClearingServer.Handlers.Callback.ValueRecv where

import Util
import qualified NoteSigner.Interface as Iface
import ClearingServer.Lib.Types     (NoteOrder, ClearSrvError(..))
import PromissoryNote.Note          (PromissoryNote)
import Data.Bitcoin.PaymentChannel  (FullPayment)
import RBPCP.Callback               (CallbackInfo(..), CallbackResponse(..))

import qualified ClearingServer.Config.Types    as Conf
import qualified Data.Aeson                     as JSON



valueReceivedHandler :: CallbackInfo -> AppM Conf.AppConf CallbackResponse
valueReceivedHandler (CallbackInfo _ _ _ orderData paym) = do
    signNote <- Iface.signNote <$> asks Conf.signerIface
    let signNoteReq r = signNote r >>= return . Iface.signResNote
        payChan = error "STUB" :: RecvPayChanX
        mkErrorResponse = return . Right .
            CallbackResponse "" . Just . cs . JSON.encode
        mkSuccessResponse note = return . Right $
            CallbackResponse (cs $ JSON.encode note) Nothing

    resE <- case fmapL ParseFailure $ JSON.eitherDecode $ cs orderData of
        Right noteOrder ->
            liftIO (signNoteReq $ Iface.NoteSignRequest paym payChan noteOrder) >>=
                \signRes -> case signRes of
                    Left e -> return $ Left $ InternalError $ show e
                    Right note -> mkSuccessResponse note
        Left e -> mkErrorResponse e

    either (errorWithDescription 500 . show) return resE
