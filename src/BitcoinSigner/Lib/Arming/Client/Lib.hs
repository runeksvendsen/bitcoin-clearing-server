module BitcoinSigner.Lib.Arming.Client.Lib
(
    module BitcoinSigner.Lib.Arming.Client.Lib
,   module BitcoinSigner.Lib.Arming.Types
)

where

import           Util
import           BitcoinSigner.Lib.Arming.Types
import qualified Network.Haskoin.Crypto         as HC

import qualified Data.ByteString.Char8          as C
import qualified System.Console.Haskeline       as Haskeline

--DEBUG
-- import           Debug.Trace
-- import           Data.Maybe                 (fromJust)
-- keyEx :: HC.XPrvKey
-- keyEx = fromJust $ HC.xPrvImport (C.pack keyExample)
-- pubEx :: HC.XPubKey
-- pubEx = fromJust $ HC.xPubImport (C.pack examplePub)


keyExample :: String
keyExample = "xprv9s21ZrQH143K3GTutskkmMZUi3V1WpqXLWGYv2iBmzrveXJJkHgyX7YUhbwnr19UoB8RvfScXnQNLaHBaxy8bUNhxSGVShDXbzprgvUJyad"

examplePub :: String
examplePub = "xpub661MyMwAqRbcFkYNzuHm8VWDG5KVvHZNhjC9iR7oLLPuXKdTHq1E4urxYuMtpEG3ryrDoNPaXKhzWMnbZJjP3vRtjigFxDAENnidSZB6AUs"

consoleReadKey :: IO HC.XPrvKey
consoleReadKey = -- log_warn "DEBUG: Using debug key & hostname" >> return keyEx
    Haskeline.runInputT Haskeline.defaultSettings haskelineReadKey

consoleReadHostname :: IO String
consoleReadHostname = -- return "localhost"
    Haskeline.runInputT Haskeline.defaultSettings haskelineReadHostname

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
