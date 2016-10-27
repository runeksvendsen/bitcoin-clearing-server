{-# LANGUAGE RecordWildCards #-}
module Util.Bitcoin.Wallet.Server
(   spawnWallet
)
where

import           Util.Bitcoin.Wallet.Interface   (Interface, mkInterface)
import           Network.Haskoin.Wallet           (Config(..))
import           Network.Haskoin.Wallet.Server    (runSPVServerWithContext)
import           Network.Haskoin.Wallet.Internals (Notif(..))
import qualified Network.Haskoin.Crypto         as HC
import           Util.Retry                               (retryTimesWithDelay)
import           Data.String.Conversions          (cs)
import qualified System.ZMQ4                    as ZMQ
import qualified Control.Monad.Logger           as Log
import qualified Control.Monad.Trans.Resource   as Resource
import qualified Data.Aeson                     as JSON
import qualified Control.Concurrent             as Con
import qualified Control.Monad                  as M
import qualified Control.Exception              as Except


spawnWallet :: Config
            -> ZMQ.Context
            -> HC.XPubKey
            -> (Notif -> IO ())
            -> IO Interface
spawnWallet conf ctx pk notifHandler = do
    -- Server
    putStrLn "Starting server..."
    _ <- Con.forkIO $ runWallet conf ctx
    -- Notify thread
    putStrLn "Starting notification thread..."
    _ <- Con.forkIO $ retryTimesWithDelay "NotifyThread" 100 100000 $ notifyThread conf ctx notifHandler  -- Give the wallet 10 seconds to boot up
    mkInterface conf ctx pk

-- |Run haskoin-wallet using the specified ZeroMQ Context,
--  and log to stderr.
runWallet :: Config -> ZMQ.Context -> IO ()
runWallet cfg ctx = run $ runSPVServerWithContext cfg ctx
    where run           = Resource.runResourceT . runLogging
          runLogging    = Log.runStderrLoggingT . Log.filterLogger logFilter
          logFilter _ l = l >= configLogLevel cfg

-- |Connect to notify socket, subscribe to new blocks,
--  and execute the supplied handler for each new block as it arrives.
notifyThread :: Config -> ZMQ.Context -> (Notif -> IO ()) -> IO ()
notifyThread Config{..} ctx handler = waitAndCatch $
    ZMQ.withSocket ctx ZMQ.Sub $ \sock -> do
        ZMQ.setLinger (ZMQ.restrict (0 :: Int)) sock
        ZMQ.connect sock configBindNotif
        ZMQ.subscribe sock "[block]"
        putStrLn "NOTIFY: Connected. Subscribed to new blocks."
        M.forever $ do
            [_,m] <- ZMQ.receiveMulti sock
            notif <- either failOnErr return $ JSON.eitherDecode (cs m)
            handler notif
  where
    failOnErr = fail . ("NOTIFY: ERROR: recv failed: " ++)
    waitAndCatch ioa = Con.threadDelay 10000 >> ioa `Except.finally` waitAndCatch ioa
