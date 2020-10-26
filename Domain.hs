{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE DeriveGeneric #-}

module Domain where

import GHC.Generics
import qualified Data.Text.Lazy as TX
import qualified Data.Text.Lazy.Encoding as TX
import Data.Aeson
import Data.Maybe
import Control.Applicative


--
--
--toString:: [Maybe Int]-> String
--toString (x:xs) | (not $ isNothing x) && (not (null xs)) = (show (fromJust x)) ++ " " ++ toString xs
--		| (not $ isNothing x) && (null xs) = show $ fromJust x
--		| (isNothing x) && (not (null xs)) = (show 0 ) ++ " " ++ toString xs
--		| (isNothing x) && (null xs) = show 0
--

--make2DArrayFromArray:: [String] -> a1 -> Int -> a2
--make2DArrayFromArray (x:xs) cal n = do
--				let temp = cal ++ [if (read x) == 0 then Nothing else Just (read x)]
--				if length temp  == n
--						then temp  : make2DArrayFromArray xs [] n
--						else make2DArrayFromArray xs (temp) n
--make2DArrayFromArray [] _ _ = []