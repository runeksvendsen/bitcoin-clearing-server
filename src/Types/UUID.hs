module Types.UUID where



import qualified Data.ByteString as BS
import qualified Data.ByteString.Base16 as B16
import qualified Crypto.Hash.SHA256 as SHA256
import           Data.Aeson (Value(String), FromJSON(..), ToJSON(..), withText)
import qualified Data.Text.Encoding as Encoding

data UUID = SHA256 BS.ByteString
class HasID a where
    getID :: a -> UUID
    serializeForID :: a -> BS.ByteString

    getID = SHA256 . SHA256.hash . serializeForID

instance ToJSON UUID where
    toJSON (SHA256 bs) = String . Encoding.decodeUtf8 . B16.encode $ bs

instance FromJSON UUID where
    parseJSON = withText "UUID" (return . SHA256 . fst . B16.decode . Encoding.encodeUtf8)
