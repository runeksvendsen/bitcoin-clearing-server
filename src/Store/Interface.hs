module Store.Interface where

import qualified Store.API as API
import           Types
import           PromissoryNote
import qualified Util.Servant.Run as Run
import qualified Servant.Common.BaseUrl as BaseUrl
import           Servant
import           Servant.Client
import           Control.Monad (void)
import qualified Types.Config as Conf
import qualified Util.Config.Parse as ConfParse
--
import qualified Network.HTTP.Client as HTTP


mkStoreInterface :: HTTP.Manager -> BaseUrl.BaseUrl -> Interface
mkStoreInterface man baseUrl =
    Interface
        (\k n -> failOnLeft =<< Run.runReq (void $ storePut' k n man baseUrl) )
        (\k   -> failOnLeft =<< Run.runReq (storeGet' k   man baseUrl) )
    where failOnLeft = either error return

data Interface = Interface {
    storePut    :: UUID -> PromissoryNote   -> IO ()
  , storeGet    :: UUID                     -> IO PromissoryNote
}

api :: Proxy API.Store
api = Proxy

storeGet' :<|> storePut' :<|> storeDel' = client api

instance Conf.FromConfig Interface where
    fromConf cfg = do
        (baseUrl, man) <- ConfParse.parseConnection "store" cfg
        return $ mkStoreInterface man baseUrl

