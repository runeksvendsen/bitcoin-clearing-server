module BitcoinSigner.Lib.Handler.Pubkey where

import Util
import qualified BitcoinSigner.Lib.Config as Conf
import qualified BitcoinSigner.Lib.KeyCounter       as Key


pubkeyHandler :: Maybe String -> AppM Conf.Config RecvPubKey
pubkeyHandler _ = do
    keyBox <- asks Conf.keyBox
    liftIO $ Key.getPubKey keyBox

