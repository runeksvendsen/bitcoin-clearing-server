{-# LANGUAGE  DeriveGeneric #-}
module ClearingServer.Types
(
    module Types
  , NoteOrder(..)
  , NoteInvoice(..)
  , PaymentMethod(..)
  , PaymentInstruction(..)
  , PaymentServerInfo(..)
)
where

import           Types
import           ClearingServer.Types.Data
import           GHC.Generics
import qualified Servant.Common.BaseUrl as BaseUrl
import           Data.Aeson (FromJSON, ToJSON)


data NoteOrder = NoteOrder
  { order_date      :: UTCTime
  , note_value      :: Amount
  , quantity        :: Word
  , payee_pk        :: UUID
  , payment_method  :: PaymentMethod
  } deriving Generic

data NoteInvoice = NoteInvoice
  { invoice_date    :: UTCTime
  , invoice_exp     :: UTCTime
  , order_ref       :: NoteOrder
  , order_total     :: Amount
  , issuer_sig      :: Signature
  } deriving Generic

data PaymentMethod =
    PayByPaymentChan    PayChanProtocol ChannelID
        deriving Generic

data PaymentInstruction =
    PayToServer PaymentServerInfo
        deriving Generic


data PaymentServerInfo = PaymentServerInfo
  { -- | URL of the payment channel server that payments are made to
    paychan_endpoint    ::  URL
    -- | Protocol spoken by the payment channel server at the 'paychan_endpoint' URL
  , paychan_protocol    ::  PayChanProtocol
  } deriving Generic

type URL = String
data PayChanProtocol = RBPCP | BitcoinJ
    deriving Generic

-- Boilerplate
instance ToJSON NoteOrder
instance FromJSON NoteOrder

instance ToJSON NoteInvoice
instance FromJSON NoteInvoice

instance ToJSON PaymentMethod
instance FromJSON PaymentMethod

instance ToJSON PaymentInstruction
instance FromJSON PaymentInstruction

instance ToJSON PaymentServerInfo
instance FromJSON PaymentServerInfo

instance ToJSON PayChanProtocol
instance FromJSON PayChanProtocol
