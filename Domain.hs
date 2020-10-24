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

data Grid = Grid {grid :: [[Maybe Integer]]} deriving (Show, Generic)
instance ToJSON Grid
instance FromJSON Grid
data GridBD = GridBD {id:: Int, gr:: TX.Text} deriving (Show, Generic)
instance ToJSON GridBD
instance FromJSON GridBD
data Req = Req {sendgr:: [[Maybe Int]], turn:: TX.Text} deriving (Show, Generic)
instance ToJSON Req
instance FromJSON Req
data Responce = Responce {sendGrid :: [[Maybe Int]], canGo:: Bool, score::Int} deriving (Show, Generic)
instance ToJSON Responce
instance FromJSON Responce


--getGrid:: Req -> [[Maybe Int]]
--getGrid (Req grid _) = grid
--
--
--getTurn:: Req -> TX.Text
--getTurn (Req _ turn) = turn
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