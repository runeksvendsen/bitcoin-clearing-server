{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}
{-# LANGUAGE MultiParamTypeClasses, TypeSynonymInstances, FlexibleInstances #-}
module NoteSigner.Types.Request where

import NoteSigner.Types.Error       (SigningError)
import ClearingServer.Lib.Types     (NoteOrder)
import Data.Bitcoin.PaymentChannel  (FullPayment, RecvPayChanX)
import PromissoryNote.Note          (PromissoryNote)

import           GHC.Generics
import qualified Data.Serialize as Bin
import qualified Data.ByteString.Lazy as BL
import qualified Servant.API.ContentTypes as Content


data NoteSignRequest = NoteSignRequest FullPayment RecvPayChanX NoteOrder
    deriving (Generic, Bin.Serialize)

data NoteSignResponse = NoteSignResponse { signResNote :: (Either SigningError PromissoryNote) }
    deriving (Generic, Bin.Serialize)


instance Content.MimeUnrender Content.OctetStream NoteSignRequest where
    mimeUnrender _ = Bin.decode . BL.toStrict
instance Content.MimeRender Content.OctetStream NoteSignRequest where
    mimeRender _ = BL.fromStrict . Bin.encode

instance Content.MimeUnrender Content.OctetStream NoteSignResponse where
    mimeUnrender _ = Bin.decode . BL.toStrict
instance Content.MimeRender Content.OctetStream NoteSignResponse where
    mimeRender _ = BL.fromStrict . Bin.encode
