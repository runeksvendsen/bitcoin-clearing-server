module BitcoinSigner.Client.Lib
(
    module BitcoinSigner.Client.Lib
,   ArmingPacket(..)
)

where

import           Util
import           BitcoinSigner.Lib.Handler.Arming (ArmingResponse(..), ArmingPacket(..))
import           Util.Crypto                      (getFirstPubKey, getRootXPubKey)
import qualified BitcoinSigner.API.Boot         as API
import qualified Network.Haskoin.Crypto         as HC
import qualified BitcoinSigner.Lib.Config       as ServerConf

import           Servant                          (Proxy(..))
import           Servant.Client                   (client)
import qualified Util.Servant.Run               as Run
import qualified Servant.Common.BaseUrl         as BaseUrl
import qualified Network.HTTP.Client            as HTTP
import qualified Network.HTTP.Client.TLS        as HTTPS
import qualified Data.ByteString.Char8          as C
import qualified System.Console.Haskeline       as Haskeline

--DEBUG
import           Debug.Trace
import           Data.Maybe                 (fromJust)
keyEx :: HC.XPrvKey
keyEx = fromJust $ HC.xPrvImport (C.pack keyExample)

pubEx :: HC.XPubKey
pubEx = fromJust $ HC.xPubImport (C.pack examplePub)


keyExample :: String
keyExample = "xprv9s21ZrQH143K3GTutskkmMZUi3V1WpqXLWGYv2iBmzrveXJJkHgyX7YUhbwnr19UoB8RvfScXnQNLaHBaxy8bUNhxSGVShDXbzprgvUJyad"

examplePub :: String
examplePub = "xpub661MyMwAqRbcFkYNzuHm8VWDG5KVvHZNhjC9iR7oLLPuXKdTHq1E4urxYuMtpEG3ryrDoNPaXKhzWMnbZJjP3vRtjigFxDAENnidSZB6AUs"

consoleReadKey :: IO HC.XPrvKey
consoleReadKey = log_warn "DEBUG: Using debug key & hostname" >> return keyEx
    -- Haskeline.runInputT Haskeline.defaultSettings haskelineReadKey

consoleReadHostname :: IO String
consoleReadHostname = return "localhost"
    -- Haskeline.runInputT Haskeline.defaultSettings haskelineReadHostname

haskelineReadKey :: Haskeline.InputT IO HC.XPrvKey
haskelineReadKey = do
    maybeInput <- Haskeline.getInputLine $ "Enter XPrvKey in wallet import format. Example:\n" ++
        "    " ++ keyExample ++ "\n:"
    case maybeInput of
        Nothing  -> liftIO (putStrLn $ "Please enter a key. Example key: " ++ keyExample) >>
            haskelineReadKey
        Just prvStr -> maybe (onInvalidKey prvStr) return (parseKey prvStr)
    where
        parseKey str = HC.xPrvImport (C.pack str)    -- HC.makeXPrvKey
        onInvalidKey k = liftIO (putStrLn $ "Failed to parse XPrvKey " ++ show k) >>
            haskelineReadKey

haskelineReadHostname :: Haskeline.InputT IO String
haskelineReadHostname = do
    maybeHostname <- Haskeline.getInputLine
        "Enter signing service hostname. Eg. 103.43.12.121 or sign.app.com: "
    case maybeHostname of
        Nothing  -> haskelineReadHostname
        Just hostname -> return hostname

sendArmingPacket :: String -> ArmingPacket -> IO ArmingResponse
sendArmingPacket hostname pkt =
    HTTP.newManager HTTPS.tlsManagerSettings >>=
        \man -> successOrThrow <$> Run.runReq (armWithKey pkt man baseUrl)
    where
        armWithKey  = client (Proxy :: Proxy API.ArmWithKey)
        baseUrl     = BaseUrl.BaseUrl BaseUrl.Http hostname (fromIntegral ServerConf.port) ""     --TODO: HTTP for testing
        successOrThrow (Right r) = r
        successOrThrow (Left e ) = error $ "Response error to sending private key: " ++ e

checkArmingResponse :: HC.XPrvKey -> ArmingResponse -> Bool
checkArmingResponse xPrv (ArmingResponse pubKeyC) = pubKeyC == getFirstPubKey xPrv

sendFinishRequest :: String -> IO ByteString
sendFinishRequest hostname =
    HTTP.newManager HTTPS.tlsManagerSettings >>=
        \man -> successOrThrow <$> Run.runReq (finishArmRequest Nothing man baseUrl)
    where
        finishArmRequest  = client (Proxy :: Proxy API.ArmSignalDone)
        baseUrl     = BaseUrl.BaseUrl BaseUrl.Http hostname (fromIntegral ServerConf.port) ""     --TODO: HTTP for testing
        successOrThrow (Right r) = r
        successOrThrow (Left e ) = error $ "Response error to sending finish request: " ++ e

