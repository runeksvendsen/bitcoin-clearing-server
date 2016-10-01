{-# LANGUAGE MultiParamTypeClasses #-}
module Store.Types where

import           Types
import           Store.Orphans ()
import           PromissoryNote
import           Data.DiskMap (DiskMap)

type AppStore = AppM (DiskMap UUID PromissoryNote)

