{-# LANGUAGE  DeriveGeneric #-}
module BitcoinSigner.Lib.Arming.Types where

import           Types
import qualified Control.Concurrent.MVar        as MV
import qualified Network.Haskoin.Crypto         as HC
import qualified Data.ByteString.Lazy           as BL
import           GHC.Generics
import qualified Data.Serialize as Bin
import qualified Servant.API.ContentTypes as Content


data ArmingPacket = ArmingPacket
    { key   :: HC.XPrvKey
    }  deriving Generic

data ArmingResponse = ArmingResponse
    { pk    :: HC.PubKeyC
    }  deriving Generic

type KeyHolder = MV.MVar (Either HC.XPrvKey HC.XPrvKey)


instance Bin.Serialize ArmingPacket
instance Bin.Serialize ArmingResponse



instance Content.MimeUnrender Content.OctetStream ArmingResponse where
    mimeUnrender _ = Bin.decode . BL.toStrict
instance Content.MimeRender Content.OctetStream ArmingResponse where
    mimeRender _ = BL.fromStrict . Bin.encode

instance Content.MimeUnrender Content.OctetStream ArmingPacket where
    mimeUnrender _ = Bin.decode . BL.toStrict
instance Content.MimeRender Content.OctetStream ArmingPacket where
    mimeRender _ = BL.fromStrict . Bin.encode
