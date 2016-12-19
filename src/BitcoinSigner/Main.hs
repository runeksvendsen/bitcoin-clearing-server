{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module BitcoinSigner.Main where

import qualified BitcoinSigner.Lib.Signing      as Sign
import qualified BitcoinSigner.Lib.Arming       as Arm

import           Util
import           Util.Crypto                      (getRootXPubKey)

import qualified Util.Bitcoin.Wallet            as Wallet
import qualified System.ZMQ4                    as ZMQ
import qualified Network.Wai.Handler.Warp       as Warp



main :: IO ()
main = ZMQ.withContext runApp

runApp :: ZMQ.Context -> IO ()
runApp ctx = do
    log_info "Waiting for private key..."
    rootPrvKey <- Arm.spawnArmingServer
    log_info "Got private key. Starting wallet service..."
    --  Start wallet thread; get the wallet interface
    iface   <- startWallet rootPrvKey walletNotifyHandler
    appConf <- Sign.buildConf rootPrvKey iface
    --  Start signing server
    log_info $ "Starting signing service on port " <> cs (show Sign.port)
    Warp.run (fromIntegral Sign.port) (Sign.cryptoApp appConf)
  where
    walletNotifyHandler = putStrLn . ("NOTIFY: " ++) . show
    startWallet rootPrvKey notify = do
        iface <- Wallet.spawnWallet Wallet.defaultConfig ctx
            (getRootXPubKey rootPrvKey) notify
        deriveWorks <- Arm.testPubKeyDerivationWorks rootPrvKey iface
        unless deriveWorks $
            error "BUG: Wallet server key derivation broken."
        return iface
