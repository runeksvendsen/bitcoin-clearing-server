module Util.Env.Parse where



import           Util                              (envRead)

import qualified Servant.Common.BaseUrl         as BaseUrl
import qualified Data.Text              as T

import qualified Network.HTTP.Client    as HTTP
import qualified Network.HTTP.Client.TLS as HTTPS


parseEnvConn :: String -> IO (Either String BaseUrl.BaseUrl)
parseEnvConn prefix = do
    hostM  <- envRead $ prefix ++ "_HOST"
    portM  <- envRead $ prefix ++ "_PORT"
    protoM <- envRead $ prefix ++ "_PROTO"
    case (hostM, portM, protoM) of
        (Just host, Just port, Just proto) -> do
            putStrLn $ "INFO: Callback endpoint: " ++
                T.unpack proto ++ "://" ++ host ++ ":" ++ show port
            return $ Right $ BaseUrl.BaseUrl (pickProto proto) host port ""
        x -> return $ Left $ show x
  where
    pickProto txt
        | T.toUpper txt == "HTTP"  = BaseUrl.Http
        | T.toUpper txt == "HTTPS" = BaseUrl.Https
        | otherwise = error $
            "Bad protocol in CALLBACK_PROTO env. Expected \"http\" or \"https\". Found: " ++ show txt

pickManagerSettings (BaseUrl.BaseUrl BaseUrl.Http _ _ _)  = HTTP.defaultManagerSettings
pickManagerSettings (BaseUrl.BaseUrl BaseUrl.Https _ _ _) = HTTPS.tlsManagerSettings

