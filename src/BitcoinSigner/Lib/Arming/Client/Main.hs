module BitcoinSigner.Lib.Arming.Client.Main where

import Util
import qualified BitcoinSigner.Lib.Arming.Client.Lib      as L
import BitcoinSigner.Lib.Arming.Client.Arm (armServer)

main :: IO ()
main = do
    -- Get arguments
    rootPrvKey <- L.consoleReadKey
    hostname   <- L.consoleReadHostname
    -- Get ready
    _ <- putStrLn ("Press ENTER to send private key to " ++ hostname) >> getLine
    -- Go!
    armRes <- armServer rootPrvKey hostname
    putStrLn $ "Done! Server said: " ++ show armRes


