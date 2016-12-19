{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}
module ClearingServer.Lib.Types
(
    module Types
  , NoteOrder(..)
  , NoteInvoice(..)
  , PaymentMethod(..)
  , PaymentInstruction(..)
  , PaymentServerInfo(..)
  , ClearSrvError(..)
)
where

import           Types
import           Util.Crypto
import           ClearingServer.Lib.Types.Data
import           ClearingServer.Lib.Types.Error
import           GHC.Generics
import qualified Servant.Common.BaseUrl as BaseUrl
import           Data.Aeson (FromJSON, ToJSON)
import qualified Data.Serialize as Bin


data NoteOrder = NoteOrder
  { order_date      :: UTCTime
  , note_value      :: Amount
  , quantity        :: Word
  , payee_pk        :: UUID
  , payment_method  :: PaymentMethod
  } deriving (Generic, ToJSON, FromJSON, Bin.Serialize)

data NoteInvoice = NoteInvoice
  { invoice_date    :: UTCTime
  , invoice_exp     :: UTCTime
  , order_ref       :: NoteOrder
  , order_total     :: Amount
  , issuer_sig      :: Signature
  } deriving (Generic, ToJSON, FromJSON, Bin.Serialize)

data PaymentMethod =
    PayByPaymentChan PayChanProtocol ChannelID
        deriving (Generic, ToJSON, FromJSON, Bin.Serialize)

data PaymentInstruction =
    PayToServer PaymentServerInfo
        deriving (Generic, ToJSON, FromJSON, Bin.Serialize)


data PaymentServerInfo = PaymentServerInfo
  { -- | URL of the payment channel server that payments are made to
    paychan_endpoint    ::  URL -- TODO: replace with BaseUrl
    -- | Protocol spoken by the payment channel server at the 'paychan_endpoint' URL
  , paychan_protocol    ::  PayChanProtocol
  } deriving (Generic, ToJSON, FromJSON, Bin.Serialize)

type URL = String
data PayChanProtocol = RBPCP | BitcoinJ
    deriving (Generic, ToJSON, FromJSON, Bin.Serialize)
