{-# LANGUAGE OverloadedStrings #-}

module Main where

import PromissoryNote.Types

import Crypto.ECC.NIST.StandardCurves
import qualified  Crypto.ECC.NIST.Base as Curve
import qualified Crypto.Fi as FP (fromInteger)
import Control.Monad.Random


import qualified Data.ByteString.Base16 as Hex
import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Char8 as C
import qualified Data.Binary as Bin

import qualified Modinv (modInv)
import qualified Data.Digest.Pure.SHA as SHA
import qualified Crypto.Secp256k1 as Secp
import qualified Crypto.Util as Crypto (bs2i, i2bs, i2bs_unsized)
import qualified Data.Maybe as Maybe
import qualified Data.Char as Char
import qualified Data.LargeWord as BigNum


main :: IO ()
main =
    let
        curve = Curve.ECi (stdc_l p256) (stdc_b p256) (stdc_p p256) (stdc_r p256)
        generatorPoint = Curve.ECPp (stdc_xp p256) (stdc_yp p256) 1
        n = stdc_r p256
        p256 = secp256k1
    in do
        privKey <- evalRandIO $ getRandomR (1,stdc_r p256 - 1)
        let privKeyBS = Bin.encode privKey --Crypto.i2bs 256 privKey
        let secpPrivKey = Maybe.fromJust . Secp.secKey $ privKeyBS
        let secpPubKey = Secp.derivePubKey secpPrivKey

        putStrLn $ "Secp PubKey: " ++ hexStr (Secp.exportPubKey True $ secpPubKey)

        k <- evalRandIO $ getRandomR (1,stdc_r p256 - 1)
        let msgBS = "test message 123"
        let hashBS = BL.toStrict . SHA.bytestringDigest $ SHA.sha256 msgBS
        let hashInt = Crypto.bs2i $ hashBS

        let pubKeyPoint = Curve.pmul curve generatorPoint privKey
        let (x,y) = Curve.export curve pubKeyPoint
        print $ hexStr (derPubKey (x,y))
        let secpImportPubKey = Maybe.fromJust $ Secp.importPubKey (derPubKey (x,y))
        putStrLn $ "PubKey X:      " ++ hexStr (Crypto.i2bs 256 x)
        let r = x `mod` n
        let s = (modinv k n *
                     (hashInt + (privKey * r) `mod` n)) `mod` n
                        where modinv a = Maybe.fromJust . Modinv.modInv a
        print (r,s)
        let sig = Secp.CompactSig (fromIntegral r) (fromIntegral s)
        print $ Secp.verifySig
            secpImportPubKey
            (Maybe.fromJust . Secp.importCompactSig $ sig)
            (Maybe.fromJust . Secp.msg $ hashBS)
        print $ secpImportPubKey



hexStr = C.unpack . Hex.encode

-- Certicom/SECG secp256k1
--  http://www.secg.org/sec2-v2.pdf (page 9)
secp256k1 = StandardCurve {
         stdc_l = 256,
         stdc_p = FP.fromInteger 256 115792089237316195423570985008687907853269984665640564039457584007908834671663,
         stdc_r = FP.fromInteger 256 115792089237316195423570985008687907852837564279074904382605163141518161494337,
         stdc_b = FP.fromInteger 256 7,
         stdc_xp = FP.fromInteger 256 55066263022277343669578718895168534326250603453777594175500187360389116729240,
         stdc_yp = FP.fromInteger 256 32670510020758816978083085130507043184471273380659243275938904335757337482424 }


-- 0x04 | <32-byte-x> | <32-byte-y>     (65 bytes)
derPubKey :: (Integer,Integer) -> BS.ByteString
derPubKey (x,y) = BS.singleton prefix `BS.append` Crypto.i2bs 256 x
    where prefix = if y `mod` 2 == 0 then 0x02 else 0x03
