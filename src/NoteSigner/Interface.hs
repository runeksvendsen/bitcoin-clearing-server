module NoteSigner.Interface
(
  Interface(..)
, NoteSignRequest(..)
, NoteSignResponse(..)
)
where

import NoteSigner.Types.Request

import qualified Types.Config               as Conf
import           Util.Env.Parse
import qualified NoteSigner.API             as API
import qualified Util.Servant.Run           as Run
import qualified Servant.Common.BaseUrl     as BaseUrl
import qualified Network.HTTP.Client        as HTTP
import           Servant
import           Servant.Client



data Interface = Interface
    { signNote        :: NoteSignRequest -> IO NoteSignResponse
    , signerIsReady   :: IO Bool
    }

mkNoteSignerIface :: (BaseUrl.BaseUrl , HTTP.Manager) -> Interface
mkNoteSignerIface (baseUrl,man) =
    Interface
        (\pi -> failOnLeft =<< Run.runReq (signNote' pi man baseUrl) )
        (       failOnLeft =<< Run.runReq (checkReady' man baseUrl) )
    where failOnLeft = either error return


api :: Proxy API.NoteSigner
api = Proxy

signNote' :<|> checkReady' = client api

instance Conf.FromConfig Interface where
    fromConf _ = do
        connM <- parseEnvConn "NOTE_SIGNER"
        case connM of
            Right baseUrl -> do
                man <- HTTP.newManager (pickManagerSettings baseUrl)
                return $ mkNoteSignerIface (baseUrl, man)
            Left e ->
                error $ "NOTE_SIGNER env: Failed to parse environment variables: " ++ e
