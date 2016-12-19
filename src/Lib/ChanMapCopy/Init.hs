module Lib.ChanMapCopy.Init where


import           Servant
import           Servant.Client
import qualified Data.Bitcoin.PaymentChannel.Types as Pay
import qualified STMContainers.Map as STM

--
--
--
-- fromStore :: Manager -> IO ChanMapCopy
-- fromStore man =
--     StoreConf.get >>=
--     \(StoreConf.Conf baseUrl _) ->
--         getOpenChans man baseUrl
--     where apiGetOpen = Proxy :: Proxy API.StoreGetOpen
--           getOpenChans = client apiGetOpen
--
