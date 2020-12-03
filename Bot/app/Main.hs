
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeOperators #-}


module Main where

import Lib
import Data.Maybe
import GHC.Generics
import           Data.Aeson            (Value)
import qualified Data.ByteString.Char8 as S8
import qualified Data.Yaml             as Yaml
import           Network.HTTP.Simple


data Grid = Grid {grid:: [[Maybe String]] } deriving (Show, Generic)
instance ToJSON Data
instance FromJson Data


move grid pos = 1


canMakeMove grid pos col | col == "black" = (isNothing ur) || (isNothing ul) || ((isNothing uurr) && fromJust ur == "white") || ((isNothing uull) && fromJust ul == "white")
                         | col == "white" = (isNothing dr) || (isNothing dl) || ((isNothing ddrr) && fromJust dr == "black") || ((isNothing ddll) && fromJust dl == "black")
                                                where
                                                  dl = grid !! ((fst  pos )+1) !!((snd pos)-1)
                                                  dr = grid !! ((fst  pos )+1) !!((snd pos)+1)
                                                  ddrr = grid !! ((fst  pos )+2) !!((snd pos)-2)
                                                  ddll = grid !! ((fst  pos )+2) !!((snd pos)+2)
                                                  ul = grid !! ((fst  pos )-1) !!((snd pos)-1)
                                                  ur = grid !! ((fst  pos )-1) !!((snd pos)+1)
                                                  uurr = grid !! ((fst  pos )-2) !!((snd pos)-2)
                                                  uull = grid !! ((fst  pos )-2) !!((snd pos)+2)



checkMove grid x y color | x < 8 && y < 8   = if (fromJust (grid !! x !! y) == color) && canMakeMove grid (x, y) color then (x, y) else makeMove grid x (y+1) color
                         | x == 8 && y == 8 = (9, 9)
                         | x < 8 && y >= 8  = makeMove grid (x+1) 0 color


makeMove grid x y color | isNothing dl = [fst  pos, snd pos, fst  pos + 1, snd pos-1]
                        | isNothing dr = [fst  pos, snd pos, fst  pos + 1, snd pos+1]
                        | isNothing ddll && fromJust dl = [fst  pos, snd pos, fst  pos + 2, snd pos-2]
                        | isNothing ddrr && fromJust dr = [fst  pos, snd pos, fst  pos + 2, snd pos+2]
                          where
                               dl = grid !! ((fst  pos )+1) !!((snd pos)-1)
                               dr = grid !! ((fst  pos )+1) !!((snd pos)+1)
                               ddrr = grid !! ((fst  pos )+2) !!((snd pos)-2)
                               ddll = grid !! ((fst  pos )+2) !!((snd pos)+2)
                               ul = grid !! ((fst  pos )-1) !!((snd pos)-1)
                               ur = grid !! ((fst  pos )-1) !!((snd pos)+1)
                               uurr = grid !! ((fst  pos )-2) !!((snd pos)-2)
                               uull = grid !! ((fst  pos )-2) !!((snd pos)+2)

work = do
      response <- httpJSON "GET http://localhost:3000/field/checkers"
      a <- checkMove response 0 0 "black"
      gr <- makeMove response a "black"
      let response'
                  = setRequestMethod "POST"
                  $ setRequestPath "http://localhost:3000/field/checkers"
                  $ setRequestQueryString [("grid",  gr)]
                  $ setRequestSecure True
                  $ setRequestPort 3000
                  $ request'
      response <- httpJSON response'
      work
main :: IO ()
main = do
      print "Started"
      work