{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module BitcoinSigner.Main where

import           Util
import           Util.Config                      (wrapArg)
import           Util.Crypto                      (getRootXPubKey)
import           BitcoinSigner.Lib.Arming.Server  (spawnArmingServer)
import qualified BitcoinSigner.Lib.App.Crypto   as Crypto
import qualified BitcoinSigner.Lib.App.Boot     as Boot
import qualified BitcoinSigner.Lib.Config       as Conf
import qualified BitcoinSigner.Lib.KeyCounter   as Key
import qualified Util.Bitcoin.Wallet            as Wallet
import           BitcoinSigner.Lib.Settle         (settleChan)
import qualified System.ZMQ4                    as ZMQ
import qualified Network.Wai.Handler.Warp       as Warp

import           BitcoinSigner.Lib.Arming.Test        (testPubKeyDerivationWorks)
import           Util.Bitcoin.Fee                     (getBestFee)


main :: IO ()
main = ZMQ.withContext runApp

walletNotifyHandle = putStrLn . ("NOTIFY: " ++) . show

runApp :: ZMQ.Context -> IO ()
runApp ctx = do
    getFeeInfo <- getFeeInfoFunc
    log_info "Waiting for private key..."
    rootPrvKey <- spawnArmingServer
    --  Start wallet thread; get the wallet interface
    log_info "Got private key. Starting wallet service..."
    iface <- Wallet.spawnWallet Wallet.defaultConfig ctx
                (getRootXPubKey rootPrvKey) walletNotifyHandle
    keyCounter <- Key.newCounter (getRootXPubKey rootPrvKey)
    let appConf = Conf.Config iface (settleChan rootPrvKey) getFeeInfo keyCounter
    deriveWorks <- testPubKeyDerivationWorks rootPrvKey iface
    unless deriveWorks $
        error "BUG: Wallet server key derivation broken."
    log_info $ "Starting signing service on port " <> cs (show Conf.port)
    --  Start crypto/sign API server
    Warp.run (fromIntegral Conf.port) (Crypto.cryptoApp appConf)

getFeeInfoFunc = do
    --  Get function that fetches fee info from bitcoinfees.21.co
--     putStr "Testing get fee info... Best zero-delay fee: "
--     print =<< getBestFee
    return getBestFee
