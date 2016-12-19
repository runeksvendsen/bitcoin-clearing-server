module BitcoinSigner.Lib.Arming.Class where

import qualified Data.Serialize as Bin
import qualified Network.Haskoin.Crypto      as HC
import qualified Servant.API.ContentTypes as Content

-- class Bin.Serialize k => IsPrivateKey k where
--     getHash :: k -> HC.Hash256
--     getHash = HC.hash256 . Bin.encode
--
-- instance IsPrivateKey HC.XPrvKey



-- instance Content.MimeUnrender Content.OctetStream BTCArmingResponse where

-- class ( IsHash       h
--       , IsPrivateKey k
--       , IsPublicKey  p
--       , IsSignature  s
--       )
--      => CryptoSystem h k p s
--
-- class IsHash a where
--     hash :: BS.ByteString -> a
--
--
-- class IsPublicKey p where
--     verify :: p -> h -> s -> Bool
--
-- class IsSignature a where
--
--
--
--
--
--
-- instance IsHash HC.Hash256 where
--     hash = HC.hash256