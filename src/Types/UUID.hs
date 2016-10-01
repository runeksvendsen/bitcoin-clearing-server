module Types.UUID
(
    UUID
  , HasUUID(..)
)
where

import qualified Data.ByteString as BS
import qualified Data.ByteString.Base16 as B16
import qualified Crypto.Hash.SHA256 as SHA256
import           Data.Aeson (Value(String), FromJSON(..), ToJSON(..), withText)
import qualified Data.Text.Encoding as Encoding
import           Data.Hashable
import           Data.DiskMap (Serializable(..), ToFileName(..))
import qualified Data.Serialize as Bin
import qualified Util.Hex as Hex

data UUID = SHA256 BS.ByteString deriving Eq

class HasUUID a where
    getID :: a -> UUID
    serializeForID :: a -> BS.ByteString

    getID = SHA256 . SHA256.hash . serializeForID


instance ToJSON UUID where
    toJSON (SHA256 bs) = String . Encoding.decodeUtf8 . B16.encode $ bs

instance FromJSON UUID where
    parseJSON = withText "UUID" (return . SHA256 . fst . B16.decode . Encoding.encodeUtf8)

instance Hashable UUID where
    hashWithSalt salt (SHA256 uuid) = salt `hashWithSalt` uuid

instance Serializable UUID where
    serialize (SHA256 bs) = bs
    deserialize bs = if BS.length bs == 32 then Right $ SHA256 bs else Left $ "UUID length not 32 bytes"

instance ToFileName UUID

instance Bin.Serialize UUID where
    put (SHA256 bs) = Bin.putByteString bs
    get = SHA256 <$> Bin.getByteString 32

instance Hex.HexBinEncode UUID where hexEncode (SHA256 bs) = B16.encode bs
instance Hex.HexBinDecode UUID where hexDecode = deserialize . fst . B16.decode