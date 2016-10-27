{-# LANGUAGE RecordWildCards #-}
module Util.Bitcoin.Wallet.Cmd where

import              Types
import              Util
import              Network.Haskoin.Wallet
-- import              Network.Haskoin.Wallet.Model
import qualified    Network.Haskoin.Crypto      as HC
import qualified    Network.Haskoin.Node.STM    as Node
import qualified    System.ZMQ4                 as ZMQ
import qualified    Data.Aeson                  as JSON
import              Data.Word


init :: Config -> ZMQ.Context -> HC.XPubKey -> IO JsonAccount
init cfg ctx pubkey = do
    accountList <- cmdListAccounts cfg ctx
    if null accountList then
             createInitialWalletAccount
        else checkAccountMatch accountList
    return $ head accountList
    where
        createInitialWalletAccount = void $ cmdNewAccount cfg ctx (mkNewAccount pubkey)
        checkAccountMatch :: [JsonAccount] -> IO ()
        checkAccountMatch acl = when (length acl /= 1) $
            error "INIT: There should be only one account in the wallet."


cmdNewAccount :: Config -> ZMQ.Context -> NewAccount -> IO JsonAccount
cmdNewAccount cfg ctx na =
    sendCmdOrFail cfg ctx (PostAccountsR na) >>=
    maybe (error "ERROR: New account-command: no response.") return

cmdListAccounts :: Config -> ZMQ.Context -> IO [JsonAccount]
cmdListAccounts cfg ctx =
    sendCmdOrFail cfg ctx (GetAccountsR listRequestAll) >>=
    maybe (error "ERROR: List command: no response.") (return . listResultItems)

cmdListAddresses :: Config -> ZMQ.Context -> Text -> Word32 -> IO [JsonAddr]
cmdListAddresses cfg ctx accountName minConf =
    sendCmdOrFail cfg ctx
        (GetAddressesR accountName AddressExternal minConf True listRequestAll) >>=
    maybe (error "ERROR: List command: no response.") (return . listResultItems)

cmdListKeys :: Config -> ZMQ.Context -> Text -> IO [JsonAddr]
cmdListKeys cfg ctx name = cmdListAddresses cfg ctx name 0

cmdGetStatus :: Config -> ZMQ.Context -> IO Node.NodeStatus
cmdGetStatus cfg ctx =
    sendCmdOrFail cfg ctx (PostNodeR NodeActionStatus) >>=
    maybe (error "ERROR: Status command: no response.") return

sendCmdOrFail :: (JSON.FromJSON a, JSON.ToJSON a)
              => Config -> ZMQ.Context -> WalletRequest -> IO (Maybe a)
sendCmdOrFail cfg ctx cmd =
    sendCmd cfg ctx cmd >>=
    either error return >>=
    \res -> case res of
        ResponseError e -> error $ "ERROR: Send cmd, ResponseError: " ++ cs e
        ResponseValid r -> return r

sendCmd :: (JSON.FromJSON a, JSON.ToJSON a)
        => Config
        -> ZMQ.Context
        -> WalletRequest
        -> IO (Either String (WalletResponse a))
sendCmd Config{..} ctx cmd =
    ZMQ.withSocket ctx ZMQ.Req $ \sock -> do
        ZMQ.setLinger (ZMQ.restrict (0 :: Int)) sock
        ZMQ.connect sock configBind
        ZMQ.send sock [] (cs $ JSON.encode cmd)
        JSON.eitherDecode . cs <$> ZMQ.receive sock

mkNewAccount :: HC.XPubKey -> NewAccount
mkNewAccount xpub = NewAccount
    { newAccountName     = "default"
    , newAccountType     = AccountRegular
    , newAccountMnemonic = Nothing
    , newAccountMaster   = Nothing
    , newAccountDeriv    = Nothing  -- Use root key
    , newAccountKeys     = [xpub]
    , newAccountReadOnly = True
    }

listRequestAll :: ListRequest
listRequestAll = ListRequest
        { listOffset  = 0
        , listLimit   = maxBound
        , listReverse = True
        }