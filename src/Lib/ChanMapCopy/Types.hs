module Lib.ChanMapCopy.Types where

import qualified Data.Bitcoin.PaymentChannel.Types as Pay
import qualified STMContainers.Map as STM
import           Data.Hashable
import qualified Data.Serialize as Bin

-- |As an additional layer of validation, the signing service
--  has an in-memory copy of all open payment channel states,
--  and verifies payments a second time.
type ChanMapCopy = STM.Map Pay.SendPubKey Pay.ReceiverPaymentChannel

data ChanMapError =
    NoSuchItem
  | PaymentError Pay.PayChanError

instance Hashable Pay.SendPubKey where
    hashWithSalt salt sendPK =
        salt `hashWithSalt` Bin.encode sendPK

-- |While the process of creating the map from the database is in progress,
--   we need to store any incoming payments for items that have not yet
--   been restored from the database.
--  When a state is restored from the database, and a value of
--   this type is encountered, we accept the given payment using the state,
--   and store this updated state in the map.
data InitItem = InitItem Pay.FullPayment
