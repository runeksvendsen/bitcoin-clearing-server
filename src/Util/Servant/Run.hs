module Util.Servant.Run where

import qualified Control.Monad.Trans.Except as ExceptT
import qualified Servant.Client as SC
import qualified Servant.Server as SS
import           Data.EitherR (fmapL)


runReq :: ExceptT.ExceptT SC.ServantError IO a -> IO (Either String a)
runReq = fmap (fmapL show) . ExceptT.runExceptT

runReq' :: ExceptT.ExceptT SC.ServantError IO a -> IO (Either SC.ServantError a)
runReq' = ExceptT.runExceptT

runHandler :: ExceptT.ExceptT SS.ServantErr IO a -> IO (Either String a)
runHandler = fmap (fmapL show) . ExceptT.runExceptT