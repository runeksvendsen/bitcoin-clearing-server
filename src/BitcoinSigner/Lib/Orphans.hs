{-# LANGUAGE MultiParamTypeClasses, TypeSynonymInstances, FlexibleInstances #-}
module BitcoinSigner.Lib.Orphans where

import           Types
import           PromissoryNote (RedeemBlock)
import qualified Data.ByteString.Lazy as BL
import qualified Data.Serialize as Bin
import qualified Servant.API.ContentTypes as Content
import           BitcoinSigner.Lib.Arming.Types (ArmingPacket, ArmingResponse)


instance Content.MimeUnrender Content.OctetStream RecvPayChanX where
    mimeUnrender _ = Bin.decode . BL.toStrict
instance Content.MimeRender Content.OctetStream RecvPayChanX where
    mimeRender _ = BL.fromStrict . Bin.encode

instance Content.MimeUnrender Content.OctetStream RedeemBlock where
    mimeUnrender _ = Bin.decode . BL.toStrict
instance Content.MimeRender Content.OctetStream RedeemBlock where
    mimeRender _ = BL.fromStrict . Bin.encode

instance Content.MimeUnrender Content.OctetStream BitcoinTx where
    mimeUnrender _ = Bin.decode . BL.toStrict
instance Content.MimeRender Content.OctetStream BitcoinTx where
    mimeRender _ = BL.fromStrict . Bin.encode

instance Content.MimeUnrender Content.OctetStream RecvPubKey where
    mimeUnrender _ = Bin.decode . BL.toStrict
instance Content.MimeRender Content.OctetStream RecvPubKey where
    mimeRender _ = BL.fromStrict . Bin.encode

