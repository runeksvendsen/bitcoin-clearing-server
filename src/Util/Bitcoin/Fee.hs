{-# LANGUAGE OverloadedStrings, DataKinds, FlexibleContexts, LambdaCase, TypeOperators #-}
module Util.Bitcoin.Fee
(
    getBestFee
,   module Types.Bitcoin.Fee
)
where

import           Util
import           Types.Bitcoin.Fee
import           Servant
import           Servant.Client
import qualified Util.Servant.Run as Run
import qualified Data.Bitcoin.PaymentChannel.Types  as Pay
import qualified Servant.Common.BaseUrl     as BaseUrl
import qualified Network.HTTP.Client        as HTTP
import qualified Network.HTTP.Client.TLS    as HTTPS
import qualified Data.Time.Units            as Time
import qualified Control.RateLimit          as Limit
import           Data.Maybe                    (listToMaybe)
import           Data.List                    (sortOn)


-- |Used if bitcoin fee service is down.
defaultFee :: Pay.SatoshisPerByte
defaultFee = Pay.SatoshisPerByte 100

saneDefaultMaxFee :: Pay.SatoshisPerByte
saneDefaultMaxFee = Pay.SatoshisPerByte 200

-- |Get lowest, zero-block-delay fee from a list of 'FeeInfo'.
--  Returns 'Nothing' if no fee is sufficient for zero-block-delay transaction.
lowestNoDelayFee :: FeeInfo -> Maybe BitcoinAmount
lowestNoDelayFee = fmap maxFee . listToMaybe . sortOn maxFee . filter isGood . fees
    where
        isGood btcFee = maxDelay btcFee == 0

getBestFee :: IO Pay.SatoshisPerByte
getBestFee = do
    fetchFee <- mkFetchFeeInfo
    maybeFee <- lowestNoDelayFee <$> fetchFee
    case maybeFee of
        Nothing  ->
            log_warn "No fee large enough for zero delay. Choosing sane max default."
            >> return saneDefaultMaxFee
        Just suggestedFee ->
            if Pay.SatoshisPerByte suggestedFee > saneDefaultMaxFee then do
                    log_warn $ "Suggested fee (" <> tshow suggestedFee <>
                               ") greater than sane default. Defaulting to " <>
                               tshow saneDefaultMaxFee
                    return saneDefaultMaxFee
                 else
                    return $ Pay.SatoshisPerByte suggestedFee

-- |Rate-limited IO action which fetches fee info from https://bitcoinfees.21.co/api
mkFetchFeeInfo :: IO (IO FeeInfo)
mkFetchFeeInfo =
    HTTP.newManager HTTPS.tlsManagerSettings >>=
    fmap (retry "BitcoinFeeInfo") . mkRateLimiter . fmap successOrThrow . Run.runReq . flip getFeeInfo baseUrl
    where
        endpointURL = "bitcoinfees.21.co"
        baseUrl = BaseUrl.BaseUrl BaseUrl.Https endpointURL 443 ""
        successOrThrow (Right r) = r
        successOrThrow (Left e ) = error $ "Error querying " ++ endpointURL ++ ": " ++ e

getFeeInfo :: HTTP.Manager -> BaseUrl.BaseUrl -> ClientM FeeInfo
getFeeInfo = client api
    where api :: Proxy GetFee
          api  = Proxy

-- 5000 req/hour: https://bitcoinfees.21.co/api
mkRateLimiter :: IO a -> IO (IO a)
mkRateLimiter f = do
    rlFunc <- Limit.generateRateLimitedFunction
        (Limit.PerExecution (1 :: Time.Second)) (const f) throwAwayFirst
    return (rlFunc ())
    where throwAwayFirst :: req -> req -> Maybe (req, resp -> (resp, resp))
          throwAwayFirst _ req2 = Just (req2, \resp -> (resp,resp))

