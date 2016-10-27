{-# LANGUAGE MultiParamTypeClasses #-}
module NoteStore.Types where

import           Types
import           NoteStore.Orphans ()
import           PromissoryNote
import           Data.DiskMap (DiskMap)

type AppStore = AppM (DiskMap UUID PromissoryNote)

