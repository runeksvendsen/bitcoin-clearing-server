{-# LANGUAGE MultiParamTypeClasses #-}
module NoteStore.Orphans where

import           Types
import           Util
import           PromissoryNote
import           Data.Hashable
import           Data.DiskMap (DiskMap,newDiskMap,
                               addItem, getItem,
                               CreateResult(..),
                               Serializable(..))
import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy as BL
import qualified Data.Serialize as Bin
import qualified Util.Hex as Hex

import qualified Servant.API.ContentTypes as Content
import qualified Web.HttpApiData as Web

instance Web.FromHttpApiData UUID where
    parseUrlPiece = fmapL cs . Hex.hexDecode . cs
instance Web.ToHttpApiData UUID where
    toUrlPiece = cs . Hex.hexEncode

instance Content.MimeUnrender Content.OctetStream UUID where
    mimeUnrender _ = deserialize . BL.toStrict
instance Content.MimeRender Content.OctetStream UUID where
    mimeRender _ = BL.fromStrict . serialize

instance Content.MimeUnrender Content.OctetStream PromissoryNote where
    mimeUnrender _ = Bin.decode . BL.toStrict
instance Content.MimeRender Content.OctetStream PromissoryNote where
    mimeRender _ = BL.fromStrict . Bin.encode

instance Serializable PromissoryNote where
    serialize = Bin.encode
    deserialize = Bin.decode

