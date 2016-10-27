{-# LANGUAGE RecordWildCards #-}
module Util.Bitcoin.Wallet.Interface where

import           Network.Haskoin.Wallet       (Config, JsonAddr)
import qualified Util.Bitcoin.Wallet.Init  as Init
import           Util.Bitcoin.Wallet.Cmd     (cmdGetStatus, cmdListKeys)
import qualified Network.Haskoin.Crypto     as HC
import qualified Network.Haskoin.Node.STM   as Node
import qualified System.ZMQ4                as ZMQ


mkInterface :: Config -> ZMQ.Context -> HC.XPubKey -> IO Interface
mkInterface cfg ctx pubkey = do
    accountName <- Init.init cfg ctx pubkey
    return $ Interface
        (cmdGetStatus cfg ctx)
        (cmdListKeys cfg ctx accountName)

data Interface = Interface
  { nodeStatus  :: IO Node.NodeStatus
  , listKeys    :: IO [JsonAddr]
--   , lookupIndex  :: HC.PubKeyC -> IO HC.KeyIndex
  }
