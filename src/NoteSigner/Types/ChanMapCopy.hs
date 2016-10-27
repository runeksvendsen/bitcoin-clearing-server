module NoteSigner.Types.ChanMapCopy where

import qualified ChanStore.API as API
-- import qualified ChanStore.Config as StoreConf
import           Servant
import           Servant.Client
import qualified Data.Bitcoin.PaymentChannel.Types as Pay
import qualified STMContainers.Map as STM

-- |The signing service has an in-memory copy of all open payment channel states
type ChanMapCopy = STM.Map Pay.SendPubKey Pay.ReceiverPaymentChannel


fromStore :: Manager -> IO ChanMapCopy
fromStore man =
    StoreConf.get >>=
    \(StoreConf.Conf baseUrl _) ->
        getOpenChans man baseUrl
    where apiGetOpen = Proxy :: Proxy API.StoreGetOpen
          getOpenChans = client apiGetOpen
