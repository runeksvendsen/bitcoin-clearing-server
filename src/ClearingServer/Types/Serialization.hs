module ClearingServer.Types.Serialization where

import ClearingServer.Types
import Data.Serialize

instance HasUUID NoteInvoice where
    serializeForID = encode

