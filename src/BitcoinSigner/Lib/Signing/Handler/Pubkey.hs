module BitcoinSigner.Lib.Signing.Handler.Pubkey where

import Util
import qualified BitcoinSigner.Lib.Signing.Config as Conf
import qualified BitcoinSigner.Lib.Signing.KeyCounter       as Key
import           Lib.Handler.Class (HasHandler(..))


instance HasHandler (Maybe String) RecvPubKey Conf.Config where
    handle = pubkeyHandler

pubkeyHandler :: Maybe String -> AppM Conf.Config RecvPubKey
pubkeyHandler _ = do
    keyBox <- asks Conf.keyBox
    liftIO $ Key.getPubKey keyBox


