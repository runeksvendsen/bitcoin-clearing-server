module NoteSigner.Handler.CheckReady where

import qualified Util.Bitcoin.ChainMap as Chain
import Util
import qualified NoteSigner.Config              as Conf


checkReady :: AppM Conf.Config Bool
checkReady = asks Conf.chainMap >>= liftIO . Chain.isReady
