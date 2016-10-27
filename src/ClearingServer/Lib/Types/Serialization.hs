module ClearingServer.Lib.Types.Serialization where

import ClearingServer.Lib.Types
import Data.Serialize

instance HasUUID NoteInvoice where
    serializeForID = encode

