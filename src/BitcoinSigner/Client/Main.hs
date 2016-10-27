module BitcoinSigner.Client.Main where

import Util
import BitcoinSigner.Client.Lib     (ArmingPacket(..), sendArmingPacket
                                    ,checkArmingResponse, sendFinishRequest
                                    ,consoleReadKey, consoleReadHostname)

main :: IO ()
main = do
    -- Get arguments
    rootPrvKey <- consoleReadKey
    hostname   <- consoleReadHostname
    -- Get ready
    putStrLn $ "Press ENTER to send private key to " ++ hostname
    _ <- getLine
    -- Go!
    armResponse <- sendArmingPacket hostname (ArmingPacket rootPrvKey)
    if checkArmingResponse rootPrvKey armResponse then
            putStrLn "Success sending packet. Finishing off..."
        else
            error "Error sending packet: SigningService's derived pubkey doesn't match ours."
    pong <- sendFinishRequest hostname
    putStrLn $ "Done! Server said: " ++ cs pong

