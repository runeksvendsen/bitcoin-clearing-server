module Types.UUID
(
    UUID
  , HasUUID(..)
)
where

import PromissoryNote

-- instance Hex.HexBinEncode UUID where hexEncode (SHA256 bs) = B16.encode bs
-- instance Hex.HexBinDecode UUID where hexDecode = Bin.decode . fst . B16.decode