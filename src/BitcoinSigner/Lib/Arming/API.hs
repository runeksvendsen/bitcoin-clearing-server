{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
{-# LANGUAGE LiberalTypeSynonyms #-}
module BitcoinSigner.Lib.Arming.API where

import           Types
import           BitcoinSigner.Lib.Arming.Types
import           Servant

type ArmWithKey k =
    -- | Arm with private key of type 'k'. Performed during service boot-up.
    "arm_missiles"   :>  ReqBody '[OctetStream] (ArmingPacket k)  :>  Post '[OctetStream] (ArmingResponse k)

type ArmSignalDone =
    -- | Tell it we're done arming.
    --   We need to kill the 'ArmWithKey' server once the key has been received,
    --    and the response delivered. This request initiates that.
    "arm_done"       :>  Header "Host" String                 :>  Get  '[OctetStream] ByteString

type Boot k = ArmWithKey k :<|> ArmSignalDone


