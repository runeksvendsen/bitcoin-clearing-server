module PromissoryNote.Serialization where

import PromissoryNote.Types
import Data.Serialize

instance HasID PromissoryNote where
    serializeForID pn@(PromissoryNote den val issueD expD isserName issuerPK verifierList negRecList) =
        encode pn
            where serNegRec (NegRec bearerPK payInfHash _) = undefined
