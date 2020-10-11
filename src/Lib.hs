module Lib
    ( add, shift', shift, printRows, printLine, printGrid, game
    ) where

import Data.Maybe (catMaybes, isNothing, fromJust, isJust)
import Data.List (transpose)
import Data.List (group)
import System.IO
--import System.Random


type Tile = Maybe Int
type Line = [Tile]
type Board = [Line]
data Action = L | R | T| D | Exit

add :: [Int] -> [Int]
add (x : y : rest) = x + y : add rest
add ts = ts

pad :: [a] -> a -> Int -> [a]
pad xs x n = take n (xs ++ repeat x)

shift v = pad ts Nothing (length v)
  where
    ts = map Just (concatMap add (group (catMaybes v)))

shift' :: Board -> Board
shift' = map shift

rotate :: Board -> Board
rotate = map reverse . transpose

clear = putStr "\ESC[2J"

printLine (x : xs) | isNothing x = if not (null xs) then "  " ++ printLine xs else "  " ++ "|"
                 | not (null xs) = show (fromJust x) ++" "++ printLine xs
                 | otherwise = show (fromJust x) ++ "|"

printRows (x:xs) = do
        print (printLine x)
        if not (null xs) then
          printRows xs
        else print "______"

printGrid grid = do
        clear
        print "OK"
        printRows grid


circle n = do
    x <- getLine
    if n > 0 then circle (n-1) else print x

calculateNothings grid = calculate $ concat grid
calculate (x:xs) | isNothing x = 1 + if not (null xs) then calculate xs else 0
                 | isJust x = 0 + if not (null xs) then calculate xs else 0

readInput = do
          x <- getLine
          if x == "w" then
                      return T
          else if x == "a" then
                      return L
          else if x == "s" then
                      return D
          else if x == "d" then
                      return R
          else return Exit


helper1 (x:xs) y | isNothing x  && y == 0 = [Just 2] ++ if not(null xs) then xs else []
		 | y == 0 = x : (helper1 xs y)
		 | y > 0 && isNothing x = x : helper1 xs (y - 1)
		 | y > 0 = x : helper1 xs y
		 | otherwise = x : xs

make2DArrayFromArray (x:xs) cal n = do
				let temp = cal ++ [x]
				if length temp  == n 
						then temp  : make2DArrayFromArray xs [] n 
						else make2DArrayFromArray xs (temp) n
make2DArrayFromArray [] _ _ = []


canGo grid = grid /= grid_d || grid /= grid_a || grid /= grid_w || grid /= grid_s where
            grid_d = rotate  $ rotate $ shift' $ rotate $ rotate grid
            grid_a = shift' grid
            grid_w = rotate $ shift' $ rotate $ rotate $ rotate grid
            grid_s = rotate $ rotate $ rotate $ shift' $ rotate grid
--getRandom n = do
--		num <- randomIO :: IO Int
--		let val = read (show num)::Integer
--		return (val `mod` n)
--(getRandom (calculateNothings grid))

getRandom n = ((n*2+3)*5) `mod` n
addRandom grid = make2DArrayFromArray (helper1 (concat grid) (getRandom (calculateNothings grid))) [] 3
game grid prev = do
          printGrid grid
          x <- getLine
	  if canGo grid then
            	if x == "a" && leftMove /= grid then
                     	game (addRandom $ leftMove) grid 
            	else if x == "d" && rigthMove/= grid then
                      	game (addRandom $ rigthMove) grid 
            	else if x == "w" && forwardMove/= grid then
                     	game (addRandom $ forwardMove) grid 
            	else if x == "s" && backMove/= grid then
                      	game (addRandom $ backMove) grid 
            	else if x == "e" then 
			game prev prev
		else game grid prev
          else print "No Turns"
	  where 
		leftMove    = shift' grid
		rigthMove   = rotate $ rotate $ shift' $ rotate $ rotate grid
		forwardMove = rotate $ shift' $ rotate $ rotate $ rotate grid
		backMove    = rotate $ rotate $ rotate $ shift' $ rotate grid
