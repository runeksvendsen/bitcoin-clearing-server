module Util.Bitcoin.Wallet.Init where

import              Util
import              Types
import              Util.Bitcoin.Wallet.Cmd
import              Network.Haskoin.Wallet
import qualified    Network.Haskoin.Crypto      as HC
import qualified    System.ZMQ4                 as ZMQ


type AccountName = Text

init :: Config -> ZMQ.Context -> HC.XPubKey -> IO AccountName
init cfg ctx pubkey = do
    accountList <- cmdListAccounts cfg ctx
    if null accountList then
             createInitialWalletAccount
        else checkAccount accountList
    where
        createInitialWalletAccount =
            cmdNewAccount cfg ctx (mkNewAccount pubkey) >>
            putStrLn "WALLET_INIT: INFO: Initialized wallet account." >>
            return (newAccountName $ mkNewAccount pubkey)
        checkAccount :: [JsonAccount] -> IO AccountName
        checkAccount acl = do
            when (length acl /= 1) $
                error "WALLET_INIT: ERROR: There should be only one account in the wallet."
            checkPubKey (head acl)
            return (jsonAccountName $ head acl)
        checkPubKey acc = when (accPubKey acc /= pubkey) $
            error $ "WALLET_INIT: ERROR: Unknown pubkey in wallet: " ++ show (accPubKey acc)
        accPubKey acc = head (jsonAccountKeys acc)

