module BitcoinSigner.Lib.Signing.KeyCounter where

import           Util
import           Util.Crypto as Crypto
import qualified Network.Haskoin.Crypto         as HC
import qualified Control.Concurrent.STM.TVar    as TV
import qualified Control.Concurrent.STM         as STM
import qualified Data.Bitcoin.PaymentChannel    as Pay


type KeyCounter = TV.TVar (HC.XPubKey,Word32)

newCounter :: HC.XPubKey -> IO KeyCounter
newCounter xPub = TV.newTVarIO (xPub,0)

getPubKey :: KeyCounter -> IO RecvPubKey
getPubKey kCnt =
    TV.readTVarIO kCnt >>=
        \(pub,idx) -> return . Util.MkRecvPubKey . HC.xPubKey $ Crypto.subKeyPub pub idx

nextPubKey :: KeyCounter -> IO ()
nextPubKey kc =
    STM.atomically $ TV.modifyTVar' kc $
        \(pub,idx) -> ( pub, idx + 1 )

