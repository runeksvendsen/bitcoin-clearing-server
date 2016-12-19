module BitcoinSigner.Lib.Arming.Client.Network where


import           Util
import           BitcoinSigner.Lib.Arming.Types   (ArmingResponse(..), ArmingPacket(..)
                                                  ,IsPrivateKey(..) )
import qualified BitcoinSigner.Lib.Arming.API   as API

import           Servant                          (Proxy(..))
import           Servant.Client                   (client)
import qualified Util.Servant.Run               as Run
import qualified Servant.Common.BaseUrl         as BaseUrl
import qualified Network.HTTP.Client            as HTTP
import qualified Network.HTTP.Client.TLS        as HTTPS


sendArmingPacket :: IsPrivateKey k => String -> Word -> ArmingPacket k -> IO (ArmingResponse k)
sendArmingPacket hostname port pkt =
    HTTP.newManager HTTPS.tlsManagerSettings >>=
        \man -> successOrThrow <$> Run.runReq (armWithKey pkt man baseUrl)
    where
        armWithKey  = client (Proxy :: Proxy (API.ArmWithKey k))
        baseUrl     = BaseUrl.BaseUrl BaseUrl.Http hostname (fromIntegral port) ""     --TODO: HTTP for testing
        successOrThrow (Right r) = r
        successOrThrow (Left e ) = error $ "Response error to sending private key: " ++ e

sendFinishRequest :: String -> Word -> IO ByteString
sendFinishRequest hostname port =
    HTTP.newManager HTTPS.tlsManagerSettings >>=
        \man -> successOrThrow <$> Run.runReq (finishArmRequest Nothing man baseUrl)
    where
        finishArmRequest  = client (Proxy :: Proxy API.ArmSignalDone)
        baseUrl     = BaseUrl.BaseUrl BaseUrl.Http hostname (fromIntegral port) ""     --TODO: HTTP for testing
        successOrThrow (Right r) = r
        successOrThrow (Left e ) = error $ "Response error to sending finish request: " ++ e

