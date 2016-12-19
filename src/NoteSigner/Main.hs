{-# LANGUAGE OverloadedStrings #-}
module NoteSigner.Main where

import Util
import qualified Util.Bitcoin.Wallet        as Wallet
import qualified Util.Bitcoin.ChainMap    as Chain
import qualified NoteSigner.Config          as Conf
import qualified NoteSigner.App             as App
import qualified Network.Wai.Handler.Warp   as Warp
import qualified Database.Persist.Sqlite    as DB
import qualified Network.Haskoin.Crypto      as HC
import qualified System.ZMQ4                    as ZMQ


privKeyFilePath = "/etc/private/note-key"

btcNet = Wallet.Testnet
dbTmpFileCfg = DB.SqliteConf "/tmpfs" 1
walletConf = Wallet.mkConfig btcNet dbTmpFileCfg
dummyXPub = HC.deriveXPubKey $ HC.makeXPrvKey
    "beefbeefbeefbeefbeefbeefbeefbeefbeefbeefbeefbeefbeefbeefbeefbeef"

main = ZMQ.withContext app

app ctx = do
    maybePort <- envRead "PORT"
    chainMap <- Chain.mkChainMap =<< Wallet.spawnWallet walletConf ctx dummyXPub (const $ return ())
    let cfg = Conf.Config privKeyFilePath chainMap
    --  Start issue/redeem app
    Warp.run (fromIntegral . fromMaybe 8080 $ maybePort) (App.noteSigner cfg)

