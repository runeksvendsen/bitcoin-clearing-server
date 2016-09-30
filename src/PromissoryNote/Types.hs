{-# LANGUAGE DeriveGeneric #-}
module PromissoryNote.Types where

import           Types
import           ClearingServer.Types.Data
import           GHC.Generics

data PromissoryNote = Note
  { denomination        ::  Currency     -- eg. BTC/USD/LTC/EUR etc.
  , face_value          ::  Amount
  , issue_date          ::  UTCTime
  , exp_date            ::  UTCTime
  , issuer_name         ::  Identity
  , issuer              ::  UUID
  , verifiers           :: [UUID]
  , negotiation_records :: [NegotiationRec]
  } deriving Generic

data NegotiationRec = NegRec
  { bearer              :: UUID
  , payment_info        :: UUID
  -- | In case of the first negotiation record the previous bearer is the issuer
  , prev_bearer_sig     :: Signature
  } deriving Generic

data PaymentInfo = PayInf
  { payment_data        :: ByteString
  } deriving Generic


