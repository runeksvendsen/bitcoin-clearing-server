{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
module Types.Bitcoin.Fee where

import           Util
import           Data.Word        (Word64)
import           Servant
import           GHC.Generics
import qualified Data.Aeson as JSON
import qualified Data.Aeson.Encode.Pretty       as PrettyJSON


-- https://bitcoinfees.21.co/api/v1/fees/list
type GetFee = "api" :> "v1" :> "fees" :> "list" :> Get '[JSON] FeeInfo

data FeeInfo = FeeInfo
    { fees  :: [BitcoinFee]
    }   deriving (Eq, Generic)

data BitcoinFee = BitcoinFee
    { minFee        :: BitcoinAmount
    , maxFee        :: BitcoinAmount
    , dayCount      :: Word64
    , memCount      :: Word64
    , minDelay      :: Word64
    , maxDelay      :: Word64
    , minMinutes    :: Word64
    , maxMinutes    :: Word64
    }  deriving (Eq, Generic)

instance JSON.ToJSON BitcoinFee
instance JSON.FromJSON BitcoinFee
instance JSON.ToJSON FeeInfo
instance JSON.FromJSON FeeInfo

instance Show FeeInfo where
    show = cs . PrettyJSON.encodePretty

instance Show BitcoinFee where
    show = cs . PrettyJSON.encodePretty