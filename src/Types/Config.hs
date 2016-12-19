{-# LANGUAGE MultiParamTypeClasses, TypeSynonymInstances #-}
module Types.Config where

import qualified Data.Configurator.Types as Configurator
-- import qualified Data.Configurator as Conf
-- import qualified Data.Maybe as Maybe
-- import qualified Control.Monad.Reader as Reader
-- import qualified Servant
-- import Data.Word (Word32, Word64)



class FromConfig opt where
    fromConf :: Configurator.Config -> IO opt

-- class ConfigGroupOpt opt group where
--     fromConf  :: Configurator.Config -> IO opt
--     get       :: group -> opt
--
-- type BtcConf = Word32
-- type OpenPrice = Word64
--
-- data ChanConf = ChanConf
--   { btcMinConf      :: BtcConf
--   , openPrice       :: OpenPrice }
--
-- instance ConfigGroupOpt BtcConf ChanConf where
--     fromConf cfg =
--         Maybe.fromMaybe (error "BtcConf") <$>
--         Conf.lookup cfg "bitcoin.min_conf"
--     get = btcMinConf
--
-- instance ConfigGroupOpt OpenPrice ChanConf where
--     fromConf cfg =
--         Maybe.fromMaybe (error "OpenPrice") <$>
--         Conf.lookup cfg "paychan.open_price"
--     get = openPrice
--
-- type AppM conf = Reader.ReaderT conf Servant.Handler
--
-- fetch :: ConfigGroupOpt opt ChanConf => AppM ChanConf opt
-- fetch = get <$> Reader.ask
--
--
-- doSomething :: ChanConf -> IO ()
-- doSomething buyCoffee = do
--     doThis
--     fetch >>= Reader.liftIO . doThat
--
--   where
--     doThis      :: BtcConf   -> IO ()
--     doThat      :: OpenPrice -> IO ()
--     andAlsoThis :: OpenPrice -> BtcConf -> Bool -> IO ()
--     doThis = undefined
--     doThat = undefined
--     andAlsoThis = undefined

