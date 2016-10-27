{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module BitcoinSigner.API.Boot where

import           Types
import           BitcoinSigner.Lib.Arming.Types
import           Servant

type ArmWithKey =
    -- | Arm with private key. Performed during service boot-up.
    "arm_missiles"   :>  ReqBody '[OctetStream] ArmingPacket  :>  Post '[OctetStream] ArmingResponse

type ArmSignalDone =
    -- | Tell it we're done arming.
    "arm_done"       :>  Header "Host" String                 :>  Get  '[OctetStream] ByteString

type Boot = ArmWithKey :<|> ArmSignalDone


