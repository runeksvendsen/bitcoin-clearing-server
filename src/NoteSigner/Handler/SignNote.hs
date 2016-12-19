module NoteSigner.Handler.SignNote where

import Util
import NoteSigner.Types
import qualified Util.Bitcoin.ChainMap as Chain
import qualified NoteSigner.Config              as Conf
import Lib.Handler.Class (HasHandler(..))


signNote :: NoteSignRequest -> AppM Conf.Config NoteSignResponse
signNote (NoteSignRequest paym order chanState) = do
    chainMap <- asks Conf.chainMap
    let lookupChain bh = liftIO $ Chain.lookup chainMap bh

--     blockInfoM <- lookupChain (chanState)

    error "STUB"

instance HasHandler NoteSignRequest NoteSignResponse Conf.Config where
    handle = signNote
