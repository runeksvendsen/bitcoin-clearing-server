module ClearingServer.Types.Response where

import ClearingServer.Types.Data

data ClientFeeInfo = FeeInfo
  { client_pubkey   ::  PubKey
  -- Cost to redeem new payment, if no further payments are made from the client before redemption.
  , redeem_fee      ::  Amount   }

data ServerInfo = ServerInfo
  { -- | URL of the payment channel server that payments are made to
    paychan_endpoint    ::  URL
    -- | Protocol spoken by the payment channel server at the 'paychan_endpoint' URL
  , paychan_protocol    ::  PayChanProtocol
  }



-- Stubs
type URL = ()
type PayChanProtocol = ()
