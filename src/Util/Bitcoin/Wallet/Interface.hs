{-# LANGUAGE RecordWildCards #-}
module Util.Bitcoin.Wallet.Interface
(
    initInterface
,   Interface(..)
)
where

import           Util.Bitcoin.Wallet.Types
import           Util.Bitcoin.Wallet.Cmd      ( runCmd
                                              , cmdGetStatus, cmdListKeys
                                              , cmdImportTx, cmdBlockInfo)

import           Types
import qualified Util.Bitcoin.Wallet.Init           as Init
import qualified Network.Haskoin.Crypto             as HC
import qualified Network.Haskoin.Node.STM   as Node
import qualified System.ZMQ4                as ZMQ



initInterface :: Config -> ZMQ.Context -> HC.XPubKey -> IO Interface
initInterface cfg ctx pubkey =
    Init.initAccount cfg ctx pubkey >>=
    mkInterface cfg ctx

mkInterface :: Config -> ZMQ.Context -> Text -> IO Interface
mkInterface cfg ctx accountName =
    return $ Interface
        nodeStatus'
        (syncedWithNetwork nodeStatus')
        (runCmd (cfg,ctx) $ cmdListKeys accountName)
        (runCmd (cfg,ctx) . cmdImportTx accountName)
        (runCmd (cfg,ctx) . cmdBlockInfo)
  where
    nodeStatus' = runCmd (cfg,ctx) $ cmdGetStatus

data Interface = Interface
  { nodeStatus  :: IO Node.NodeStatus
  , networkSync :: IO Bool
  , listKeys    :: IO [JsonAddr]
  , importTx    :: BitcoinTx -> IO JsonTx
  , blockInfo   :: BlockHash -> IO (Maybe BlockInfo)
  }


syncedWithNetwork :: IO Node.NodeStatus -> IO Bool
syncedWithNetwork nodeStatus =
    nodeStatus >>= \ns ->
        return $ Node.nodeStatusBestHeaderHeight ns == Node.nodeStatusNetworkHeight ns

