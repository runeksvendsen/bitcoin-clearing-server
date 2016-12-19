module ClearingServer.Handlers.Redeem where

import Types
import PromissoryNote
import qualified ClearingServer.Config.Types as Conf


noteRedemptionHandler :: [RedeemBlock] -> AppM Conf.AppConf BitcoinTx
noteRedemptionHandler redeemBlkLst = do
    let handleBlock (RedeemBlock notes negRec _) = undefined
        negRecRedeemAddr = undefined

    -- Verify promissory notes:
    --  1. Issued by us
    --  2. Negotiated to us
    --  3. Dest. address is valid

    -- Perform global keys-only query for 'notes':
    --   returns: chanNoteIndex = Map SendPubKey [UUID]

    -- For (key,noteUUIDs) in chanNoteIndex:
    --   1. Set chan to busy (payment in progress)
    --      returns: chanNoteInfo = Map SendPubKey ([UUID], chan_val_received, chan_payment_count)

    -- noteSumValue = sum (map faceValue notes)
    --  1. if noteSum
    --  2. Global query chanNoteInfo: sort channels by chan_val_received
    --   TODO: get smallest subset of channels that covers value

    let stdBtcFee = 80
        closedChans = undefined

    -- let feeWeightMap = forValue chanNoteInfo (\(uuidL, _, chanPayCnt) ->
    --          length uuidL / (realToFrac chanPayCnt :: Double) )
    -- let feeSum = sum $ map snd . Map.toList $ forValue feeWeightMap (* stdBtcFee)

    -- payToAddresses
    --      (unique $ map getRedeemAddr redeemBlkLst)
    --      (noteSumValue - feeSum)




    error "STUB"
