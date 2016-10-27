{-# LANGUAGE MultiParamTypeClasses, TypeSynonymInstances, FlexibleInstances #-}
module BitcoinSigner.Lib.Handler.Class where

import           Types
import qualified BitcoinSigner.Lib.Config as Conf
import           PromissoryNote

import           BitcoinSigner.Lib.Handler.Redeem         (redeemHandler)
import           BitcoinSigner.Lib.Handler.Settle         (settleHandler)
import           BitcoinSigner.Lib.Handler.Pubkey         (pubkeyHandler)
import           BitcoinSigner.Lib.Handler.Arming         (armingHandler, ArmingPacket, ArmingResponse)
import           BitcoinSigner.Lib.Handler.ArmingDone     (armingFinish)
import           BitcoinSigner.Lib.Arming.Types           (KeyHolder)


-- |Class for HTTP requests that can be handled, with a request body
--   of type 'req' and a response of type 'res', with an in-handler
--   available config of type 'conf'
class HasHandler req res conf where
    handle :: req -> AppM conf res

instance HasHandler RedeemBlock BitcoinTx Conf.Config where
    handle = redeemHandler

instance HasHandler RecvPayChanX BitcoinTx Conf.Config where
    handle = settleHandler

instance HasHandler (Maybe String) RecvPubKey Conf.Config where
    handle = pubkeyHandler

instance HasHandler ArmingPacket ArmingResponse KeyHolder where
    handle = armingHandler

instance HasHandler (Maybe String) ByteString KeyHolder where
    handle = armingFinish

