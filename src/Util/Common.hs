module Util.Common
(
    cs
,   (<>)
,   void, when, unless
,   fmapL
,   fromMaybe, listToMaybe
,   MonadIO, liftIO
,   tshow
)

where

import           Data.String.Conversions (cs)
import           Data.Monoid ((<>))
import           Control.Monad (void, when, unless)
import           Data.EitherR (fmapL)
import           Data.Maybe (listToMaybe, maybeToList, fromMaybe)
import           Control.Monad.IO.Class (MonadIO, liftIO)
import           Data.Text

tshow :: Show a => a -> Text
tshow = cs . show
