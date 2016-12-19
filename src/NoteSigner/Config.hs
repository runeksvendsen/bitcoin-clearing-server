module NoteSigner.Config where

import Util.Bitcoin.ChainMap (ChainMap)

data Config = Config
    { privKeyFile   :: FilePath
    , chainMap      :: ChainMap
    }