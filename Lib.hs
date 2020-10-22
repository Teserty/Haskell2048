{-# LANGUAGE OverloadedStrings #-}
module Lib
    ( add, shift', shift, Board, Line, Tile, makeTurn, canMakeTurn, createRandomStart, addRandom, getRandom, helper1, make2DArrayFromArray, createRandomStartWithoutError, cscore, quicksort, toIntArr
    ) where

import Data.Maybe (catMaybes, isNothing, fromJust, isJust)
import Data.List (transpose)
import Data.List (group)
import System.IO
import           Data.Text.Lazy     (Text)
import System.IO.Unsafe
import System.IO
import System.Random


type Tile = Maybe Int
type Line = [Tile]
type Board = [Line]
data Action = L | R | T| D | Exit




add :: [Int] -> [Int]
add (x : y : rest) = x + y : add rest
add ts = ts

pad :: [a] -> a -> Int -> [a]
pad xs x n = take n (xs ++ repeat x)

shift:: [Maybe Int] -> [Maybe Int]
shift v = pad ts Nothing (length v)
  where
    ts = map Just (concatMap add (group (catMaybes v)))

shift' :: Board -> Board
shift' = map shift

rotate :: Board -> Board
rotate = map reverse . transpose

--clear = putStr "\ESC[2J"
--
--printLine (x : xs) | isNothing x = if not (null xs) then "  " ++ printLine xs else "  " ++ "|"
--                 | not (null xs) = show (fromJust x) ++" "++ printLine xs
--                 | otherwise = show (fromJust x) ++ "|"
--
--printRows (x:xs) = do
--        print (printLine x)
--        if not (null xs) then
--          printRows xs
--        else print "______"
--
--printGrid grid = do
--        clear
--        print "OK"
--        printRows grid

start = [[Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing]]

make2DArrayFromArray (x:xs) cal n = do
				let temp = cal ++ [x]
				if length temp  == n
						then temp  : make2DArrayFromArray xs [] n
						else make2DArrayFromArray xs (temp) n
make2DArrayFromArray [] _ _ = []


helper1 (x:xs) y | isNothing x  && y == 0 = if ((unsafePerformIO (getStdRandom (randomR (0, 4))))::Int) > 3 then [Just 4] else [Just 2] ++ if not(null xs) then xs else []
		             | not(isNothing x) && y == 0 = x : (helper1 xs y)
                 | isNothing x && y > 0 = x : helper1 xs (y - 1)
                 | not(isNothing x) && y > 0 = x : helper1 xs y
                 | otherwise = x : xs


canMakeTurn::[[Maybe Int]]->Bool
canMakeTurn grid = grid /= grid_d || grid /= grid_a || grid /= grid_w || grid /= grid_s where
            grid_d = rotate  $ rotate $ shift' $ rotate $ rotate grid
            grid_a = shift' grid
            grid_w = rotate $ shift' $ rotate $ rotate $ rotate grid
            grid_s = rotate $ rotate $ rotate $ shift' $ rotate grid


getRandom:: Int -> Int
getRandom n = ((unsafePerformIO (getStdRandom (randomR (0, 999))))::Int) `mod` n


calculateNothings grid = calculate $ concat grid
calculate (x:xs) | isNothing x = 1 + if not (null xs) then calculate xs else 0
                 | isJust x = 0 + if not (null xs) then calculate xs else 0

addRandom grid = make2DArrayFromArray (helper1 (concat grid) random) [] len
                where
                random = getRandom nums
                    where
                    nums = calculateNothings grid
                len = length grid

--game grid prev = do
--          printGrid grid
--          x <- getLine
--	  if canGo grid then
--            	if x == "a" && leftMove /= grid then
--                     	game (addRandom $ leftMove) grid
--            	else if x == "d" && rigthMove/= grid then
--                      	game (addRandom $ rigthMove) grid
--            	else if x == "w" && forwardMove/= grid then
--                     	game (addRandom $ forwardMove) grid
--            	else if x == "s" && backMove/= grid then
--                      	game (addRandom $ backMove) grid
--            	else if x == "e" then
--			game prev prev
--		else game grid prev
--          else print "No Turns"
--	  where
--		leftMove    = shift' grid
--		rigthMove   = rotate $ rotate $ shift' $ rotate $ rotate grid
--		forwardMove = rotate $ shift' $ rotate $ rotate $ rotate grid
--		backMove    = rotate $ rotate $ rotate $ shift' $ rotate grid


createRandomStart grid n | n > 1 =  createRandomStart (addRandom grid) (n-1)
                         | otherwise = addRandom grid


createRandomStartWithoutError = do
                  let grid = createRandomStart start 2
                  if (length $ concat grid) == 16 then grid
                  else createRandomStartWithoutError
makeTurn:: [[Maybe Int]]-> Text -> [[Maybe Int]]
makeTurn grid x =
    if canMakeTurn grid then
                	if x == "a" && leftMove /= grid then
                         	addRandom $ leftMove
                	else if x == "d" && rigthMove/= grid then
                          addRandom rigthMove
                	else if x == "w" && forwardMove/= grid then
                         	addRandom forwardMove
                	else if x == "s" && backMove/= grid then
                          addRandom backMove
                	else
    			                grid
    		else
    		  grid
    	  where
    		leftMove    = shift' grid
    		rigthMove   = rotate $ rotate $ shift' $ rotate $ rotate grid
    		forwardMove = rotate $ shift' $ rotate $ rotate $ rotate grid
    		backMove    = rotate $ rotate $ rotate $ shift' $ rotate grid


quicksort :: Ord a => [a] -> [a]
quicksort []     = []
quicksort (p:xs) = (quicksort lesser) ++ [p] ++ (quicksort greater)
    where
        lesser  = filter (< p) xs
        greater = filter (>= p) xs

toIntArr:: [Maybe Int] -> [Int]
toIntArr (x:xs) | isNothing x = [0::Int] ++ toIntArr xs
                | otherwise = [fromJust x] ++ toIntArr xs
toIntArr [] = []


cscore:: [[Maybe Int]] -> Int
cscore arr = sum $ toIntArr $ concat arr

