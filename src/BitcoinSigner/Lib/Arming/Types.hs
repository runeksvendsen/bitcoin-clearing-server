{-# LANGUAGE  DeriveGeneric, FlexibleInstances #-}
module BitcoinSigner.Lib.Arming.Types
(
  module BitcoinSigner.Lib.Arming.Types
-- , module BitcoinSigner.Lib.Arming.Crypto.Class
)
where

-- import           BitcoinSigner.Lib.Arming.Crypto.Class
import qualified Control.Concurrent.MVar        as MV
import qualified Network.Haskoin.Crypto         as HC
import qualified Data.ByteString.Lazy           as BL
import           GHC.Generics
import qualified Data.Serialize as Bin
import qualified Servant.API.ContentTypes as Content


class Bin.Serialize k => IsPrivateKey k where
    getHash :: k -> HC.Hash256
    getHash = HC.hash256 . Bin.encode

    mkArmingPacket :: k -> ArmingPacket k
    mkArmingPacket = ArmingPacket

    mkArmingResponse :: k -> ArmingResponse k
    mkArmingResponse = ArmingResponse . getHash

    validArmingResponse :: IsPrivateKey k => k -> ArmingResponse k -> Bool
    validArmingResponse key (ArmingResponse prvKeyHash) =
        getHash key == prvKeyHash


data ArmingPacket k = ArmingPacket
    { key   :: k
    }  deriving (Generic, Show)

data ArmingResponse k = ArmingResponse
    { keyHash :: HC.Hash256
    }  deriving (Generic, Show)


instance IsPrivateKey k => Bin.Serialize (ArmingPacket k)
instance IsPrivateKey k => Bin.Serialize (ArmingResponse k)

instance IsPrivateKey k => Content.MimeUnrender Content.OctetStream (ArmingResponse k) where
    mimeUnrender _ = Bin.decode . BL.toStrict
instance IsPrivateKey k => Content.MimeRender Content.OctetStream (ArmingResponse k) where
    mimeRender _ = BL.fromStrict . Bin.encode

instance IsPrivateKey k => Content.MimeUnrender Content.OctetStream (ArmingPacket k) where
    mimeUnrender _ = Bin.decode . BL.toStrict
instance IsPrivateKey k => Content.MimeRender Content.OctetStream (ArmingPacket k) where
    mimeRender _ = BL.fromStrict . Bin.encode



type KeyHolder k = MV.MVar (Either () k)

instance IsPrivateKey HC.XPrvKey
type BTCKeyHolder      = KeyHolder HC.XPrvKey
type BTCArmingPacket   = ArmingPacket HC.XPrvKey
type BTCArmingResponse = ArmingResponse HC.XPrvKey



