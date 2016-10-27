module Util.Retry where

import Util.Log
import Util.Common
import Control.Exception.Lifted
import qualified Control.Concurrent             as Con


retry :: String -> IO a -> IO a
retry label = retryTimes label 10

retryTimes :: String -> Int -> IO a -> IO a
retryTimes label count = retryTimesWithDelay label count 0

retryTimesWithDelay :: String -> Int -> Int -> IO a -> IO a
retryTimesWithDelay label retryCount delayMicroSecs effect =
    try effect >>= either handleRetry return
    where handleRetry e
            | retryCount > 0 = do
                Con.threadDelay delayMicroSecs
                retryTimesWithDelay label (retryCount-1) delayMicroSecs effect
            | otherwise = do
                log_error $ "RETRY FAIL: retry (" <> tshow label <>
                    "): tried without success. exception: " <> tshow e
                throwIO (e :: SomeException)

