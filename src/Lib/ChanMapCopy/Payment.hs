module Lib.ChanMapCopy.Payment where

import           Lib.ChanMapCopy.Types

import           Data.Bitcoin.PaymentChannel.Types
import qualified Data.Bitcoin.PaymentChannel    as Pay
import qualified STMContainers.Map              as STM
import           Control.Concurrent.STM           (STM)
import qualified Data.Time.Clock                as Time


checkPayUpdate
    :: ChanMapCopy
    -> Pay.FullPayment
    -> Time.UTCTime
    -> STM (Either ChanMapError Pay.BitcoinAmount)
checkPayUpdate map payment now =
    STM.lookup key map >>=
        \chanM -> case chanM of
            Nothing   -> return $ Left NoSuchItem
            Just chan -> either
                (return . Left . PaymentError)
                (fmap Right . updateMap)
                (recvPayment chan)
  where
    key = Pay.getSendPubKey payment
    recvPayment :: RecvPayChan -> Either PayChanError (BitcoinAmount,RecvPayChan)
    recvPayment s = Pay.recvPayment now s payment
    updateMap :: (BitcoinAmount,RecvPayChan) -> STM BitcoinAmount
    updateMap (a,newS) =
        STM.insert newS key map >>
        return a




