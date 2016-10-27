{-# LANGUAGE OverloadedStrings, TypeSynonymInstances, FlexibleInstances, DataKinds, MultiParamTypeClasses #-}
module ClearingServer.Config.Example where

import           Data.String.Conversions (cs)
import qualified Data.Tagged as Tag
import qualified Servant.Common.BaseUrl as BaseUrl
import           Servant.Server.Internal.Context
import qualified Data.Configurator.Types as Configurator
import qualified Data.Configurator as Conf
import qualified Control.Monad.Trans.Reader as Reader


class FromConfig a where
    fromConf :: Configurator.Config -> IO a

loadConfig :: String -> IO Configurator.Config
loadConfig confFile = Conf.load [Conf.Required confFile]

configLookupOrFail :: Configurator.Configured a =>
    Configurator.Name
    -> Configurator.Config
    -> IO a
configLookupOrFail conf name =
    Conf.lookup conf name >>= maybe
        (fail $ "ERROR: Failed to read key \"" ++ cs name ++
            "\" in config (key not present or invalid)")
        return

---
data Weight
type WeightKg = Tag.Tagged Weight Word
instance FromConfig Weight where
    fromConf = configLookupOrFail "weight"

data Height
type HeightMeters = Tag.Tagged Height Word
instance FromConfig HeightMeters where
    fromConf = configLookupOrFail "height"

data Height
type ShoeSize = Tag.Tagged Height Word
instance FromConfig HeightMeters where
    fromConf = configLookupOrFail "height"


-- New style
type AppConf = Context '[ChanManagerConn, PayChanConn, CallbackPort]

instance FromConfig AppConf where
    fromConf cfg = do
        a <- fromConf cfg
        b <- fromConf cfg
        c <- fromConf cfg
        return $ a :. b :. c :. EmptyContext

type AppM = Reader.ReaderT AppConf