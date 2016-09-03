module Types.Response where

import Types.Data

data ClientFeeInfo = FeeInfo
  { client_pubkey   ::  PubKey
  -- Cost to redeem new payment, if no further payments are made from the client before redemption.
  , redeem_fee      ::  Amount   }



-- Stubs
type ServerInfo = ()