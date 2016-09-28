module ClearingServer.Types
(
    NoteOrder(..)
  , NoteInvoice(..)
  , BS.ByteString
  , PaymentTerms(..)
)
where

import           ClearingServer.Types.Data

import qualified Data.Bitcoin.PaymentChannel.Types as PayChan
import qualified Network.Haskoin.Transaction as HT
import qualified Data.ByteString as BS


data NoteOrder = NoteOrder
  { order_date      :: UTCTime
  , note_value      :: Amount
  , quantity        :: Word
  , payee_pk        :: PubKeyHash
  , paymement_terms :: PaymentTerms
  }

data NoteInvoice = NoteInvoice
  { order           :: NoteOrder
  , amount_fees     :: Amount
  , amount_total    :: Amount
  , invoice_exp     :: UTCTime
  , issuer_sig      :: Signature
  }


-- |
data PaymentTerms =
    PayByPaymentChan    PubKey

