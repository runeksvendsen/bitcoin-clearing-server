module ClearingServer.Handlers.Solvency where

import Types
import PromissoryNote
import qualified ClearingServer.Config.Types as Conf


solvencyHandler :: AppM Conf.AppConf Int
solvencyHandler  = do

    -- Get all (open/closed) channels.
    --  * Global keys-only query
    --     returns: [SendPubKey]

    -- 1000 at a time
    -- https://cloud.google.com/datastore/docs/concepts/limits

    error "STUB"
