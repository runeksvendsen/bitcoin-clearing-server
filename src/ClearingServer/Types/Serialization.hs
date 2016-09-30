module ClearingServer.Types.Serialization where

import ClearingServer.Types
import Data.Serialize

instance HasID NoteInvoice where
    serializeForID = encode

