{-# LANGUAGE DeriveGeneric #-}
module PromissoryNote.Redeem where

import           PromissoryNote.Note
import           Types
import           Util.Crypto
import           GHC.Generics


data RedeemBlock = RedeemBlock
  { notes           :: [PromissoryNote]
  , pay_to_addr     :: BitcoinAddress
  , signature       :: Signature
  } deriving Generic

