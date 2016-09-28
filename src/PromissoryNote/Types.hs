module PromissoryNote.Types where

import           ClearingServer.Types
import           ClearingServer.Types.Data

import qualified Data.Bitcoin.PaymentChannel.Types as PayChan
import qualified Network.Haskoin.Transaction as HT
import           Data.Word (Word64)


data PromissoryNote = Note
  { denomination        :: Currency     -- eg. BTC/USD/LTC/EUR etc.
  , face_value          :: Amount
  , issue_date          :: UTCTime
  , exp_date            :: UTCTime
  , issuer_name         :: Identity
  , issuer              :: Hash PubKey
  , verifiers           :: [Hash PubKey]
  , negotiation_records :: [NegotiationRec]
  }

data NegotiationRec = NegRec
  { bearer              :: Hash PubKey
  , payment_info        :: Hash PaymentInfo
  -- | In case of the first negotiation record the previous bearer is the issuer
  , prev_bearer_sig     :: Signature
  }

data PaymentInfo = PayInf
  { payment_data        :: ByteString
  }









