module PromissoryNote.Types where

import           Types.Data

import qualified Data.Bitcoin.PaymentChannel.Types as PayChan
import qualified Network.Haskoin.Transaction as HT
import           Data.Word (Word64)


-- |Promissory note
data Note = Note
  { issue_date          :: UTCTime
  , exp_date            :: UTCTime
  , face_value          :: Amount
  , issuer_name         :: Identity
  , issuer_pk           :: PubKey
  , payee               :: PubKey   }


data NoteOrder = NoteOrder
  { order_date      :: UTCTime
  , note_value      :: Amount
  , quantity        :: Word
  , payee_pk        :: PubKey
  , paymement_terms :: PaymentTerms }


data NoteInvoice = NoteInvoice
  { order           :: NoteOrder
  , amount_fees     :: Amount
  , amount_total    :: Amount
  , issuer_sig      :: Signature    }


data PaidInvoice = PaidInvoice
  { invoice         ::  NoteInvoice
  , payment         ::  Payment }


-- |
data PaymentTerms =
    PayByPaymentChan    PubKey

data Payment =
    PayChanPayment      PayChan.Payment











