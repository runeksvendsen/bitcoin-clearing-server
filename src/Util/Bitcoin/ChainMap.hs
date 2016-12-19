{-# LANGUAGE RecordWildCards #-}
module Util.Bitcoin.ChainMap
(
  ChainMap
, mkChainMap
, lookup, isReady
)
where

import Prelude hiding (lookup)

import Util.Bitcoin.Wallet.Types
import qualified Util.Bitcoin.Wallet.Interface  as Iface
import qualified STMContainers.Map              as Map
import qualified Control.Concurrent.STM         as STM
import           Data.Hashable
import qualified Data.Serialize as Bin


type CacheMap   = Map.Map BlockHash (Maybe BlockInfo)
data ChainMap = ChainMap
    { ccMap     :: CacheMap
    , ccIface   :: Iface.Interface
    }


mkChainMap :: Iface.Interface -> IO ChainMap
mkChainMap iFace = Map.newIO >>= \m -> return $ ChainMap m iFace

lookup :: ChainMap -> BlockHash -> IO (Maybe BlockInfo)
lookup ChainMap{..} bh = do
    cacheRes <- STM.atomically $ Map.lookup bh ccMap
    case cacheRes of
        Just res -> logDebug "ChainMap: Returning cached item" >> return res
        Nothing  -> fetchAndCache bh
  where
    fetchAndCache h = do
        val <- Iface.blockInfo ccIface h
        STM.atomically $ Map.insert val h ccMap
        logDebug $ "ChainMap: Fetched+cached new item: " ++ show val
        return val

isReady :: ChainMap -> IO Bool
isReady ChainMap{..} = Iface.networkSync ccIface


logDebug = putStrLn

instance Hashable BlockHash where
    hashWithSalt s = hashWithSalt s . Bin.encode

