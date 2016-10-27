module Util.Log where

import           Data.String.Conversions (cs)
import           Data.Monoid ((<>))
import           Control.Monad.IO.Class (MonadIO, liftIO)
import           Data.Text

log_info :: Text -> IO ()
log_info = putStrLn . cs . ("  INFO: " <>)
log_info' :: MonadIO m => Text -> m ()
log_info' = liftIO . log_info

log_warn :: Text -> IO ()
log_warn = putStrLn . cs . ("  WARN: " <>)
log_warn' :: MonadIO m => Text -> m ()
log_warn' = liftIO . log_warn

log_error :: Text -> IO ()
log_error = putStrLn . cs . ("  ERROR: " <>)
log_error' :: MonadIO m => Text -> m ()
log_error' = liftIO . log_error
