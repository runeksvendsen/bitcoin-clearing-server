{-# LANGUAGE MultiParamTypeClasses #-}

module IssueStore.Types where

import           Types

import           Data.DiskMap (newDiskMap,
                            addItem, getItem,
                            CreateResult(..))

import           Data.Hashable

import           PromissoryNote.Types

import           ClearingServer.Types


class HasID item => IsStorable item where
    storeGet        :: UUID -> IO item
    storePut        :: item -> IO CreateResult
    _getDiskMap     :: IO (DiskMap UUID item)
    hash2MapKey     :: item -> Int  -- Used by the map implementation

    storePut item = _getDiskMap >>= \m -> addItem m (getID item) item
    storeGet id   = _getDiskMap >>= flip getItem id
    hash2MapKey salt a = salt `hashWithSalt` getID a




type InvoiceMap = DiskMap UUID NoteInvoice
type NoteMap    = DiskMap UUID PaymentInfo


instance Hashable PromissoryNote where hashWithSalt = hash2MapKey
instance Hashable NoteInvoice    where hashWithSalt = hash2MapKey

