module BitcoinSigner.Lib.Arming.Client.Arm where

import Util
import qualified BitcoinSigner.Lib.Arming.Client.Lib      as L
import qualified BitcoinSigner.Lib.Arming.Client.Network  as N
import qualified BitcoinSigner.Lib.Arming.Constants       as C
import           BitcoinSigner.Lib.Arming.Types             (IsPrivateKey,
                                                             validArmingResponse)

armServer :: IsPrivateKey k => k -> String -> IO ByteString
armServer rootPrvKey hostname = do
    armResponse <- N.sendArmingPacket hostname C.port (L.ArmingPacket rootPrvKey)
    unless (validArmingResponse rootPrvKey armResponse) $
        error . unlines $
            [ "Arming error: Private key checksum mismatch."
            , "Original key hash: " ++ show (L.getHash rootPrvKey)
            , "Response: " ++ show armResponse ]
    N.sendFinishRequest hostname C.port



