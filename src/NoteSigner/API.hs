{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module NoteSigner.API where

import Types                    (RecvPayChanX, FullPayment)
import NoteSigner.Types.Request (NoteSignRequest, NoteSignResponse)
import Servant


-- |Request for creating a new PromissoryNote from a NoteOrder, received in a payment
--  to PayChanServer.
type SignNote =
    "sign_note"   :> ReqBody '[OctetStream] NoteSignRequest  :> Post '[OctetStream] NoteSignResponse

type CheckReady =
    "check_ready" :> Get '[JSON] Bool

type NoteSigner = SignNote :<|> CheckReady