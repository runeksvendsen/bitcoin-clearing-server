{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module BitcoinSigner.API.Crypto where

import           Types
import           PromissoryNote
import           Servant


type BTCSign =
        -- | Produce Bitcoin transaction that moves received payment channel funds to server pubkey/address
        "settle_channel" :>  ReqBody '[OctetStream] RecvPayChanX  :>  Post '[OctetStream] BitcoinTx
        -- | Produce Bitcoin transaction that sends funds to redeemer's address
  :<|>  "redeem_notes"   :>  ReqBody '[OctetStream] RedeemBlock   :>  Post '[OctetStream] BitcoinTx
                             -- (Adding Host header is a hack so I can make its handler a class instance of 'HasHandler',
                             --  which says the handler needs an argument of some type)
  :<|>  "pubkey"         :>  Header "Host" String                 :>  Get  '[OctetStream] RecvPubKey
