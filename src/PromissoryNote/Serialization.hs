module PromissoryNote.Serialization where

import           PromissoryNote.Note
import           PromissoryNote.Redeem
import qualified Data.Serialize as Bin
import qualified Data.Aeson as JSON
import           Types.Orphans ()

instance Bin.Serialize PromissoryNote
instance Bin.Serialize NegotiationRec
instance Bin.Serialize PaymentInfo
instance Bin.Serialize RedeemBlock

instance JSON.FromJSON PromissoryNote
instance JSON.FromJSON NegotiationRec
instance JSON.FromJSON PaymentInfo

instance JSON.ToJSON PromissoryNote
instance JSON.ToJSON NegotiationRec
instance JSON.ToJSON PaymentInfo