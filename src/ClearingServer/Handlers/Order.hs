module ClearingServer.Handlers.Order where

import Types
import ClearingServer.Lib.Types
import qualified ClearingServer.Config.Types as Conf


noteOrderHandler :: NoteOrder -> AppM Conf.AppConf NoteInvoice
noteOrderHandler order =
    error "STUB"
