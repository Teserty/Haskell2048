{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import Db
import Domain
import Lib
import Web.Scotty
import Web.Scotty.Internal.Types (ActionT)
import Network.Wai
import Network.Wai.Middleware.Static
import Network.Wai.Middleware.RequestLogger (logStdoutDev, logStdout)
import Network.Wai.Middleware.HttpAuth
import Control.Applicative
import Control.Monad.IO.Class
import GHC.Generics
import           Data.Maybe
import           Data.Monoid        ((<>))
import           Data.Text.Lazy     (Text)
import           Data.Text.Lazy
import           System.Environment (lookupEnv)
import           Web.Scotty         (ActionM, ScottyM, scotty)
import Data.Monoid (mconcat)
import Data.Aeson (FromJSON, ToJSON)
import           Data.Aeson      (object, (.=))
import qualified Data.Aeson  as Ae
import           Data.Aeson               (Value, encode, object, (.=))
import Network.Wai.Middleware.Cors
import Data.Aeson.TH           (defaultOptions, deriveJSON)
import Data.Text.Lazy.Encoding (decodeUtf8)
import qualified Data.Configurator as C
import qualified Data.Configurator.Types as C
import Data.Pool(Pool, createPool, withResource)
import qualified Data.Text.Lazy as TL
import Web.Scotty
import Database.PostgreSQL.Simple
import Test.HUnit
import qualified Data.Text.Lazy as TX
import qualified Data.Text.Lazy.Encoding as TX
-- Parse file "application.conf" and get the DB connection info
--makeDbConfig :: C.Config -> IO (Maybe Db.DbConfig)
--makeDbConfig conf = do
--  name <- C.lookup conf "database.name" :: IO (Maybe String)
--  user <- C.lookup conf "database.user" :: IO (Maybe String)
--  password <- C.lookup conf "database.password" :: IO (Maybe String)
--  return $ DbConfig <$> name
--                    <*> user
--                    <*> password

-- The function knows which resources are available only for the
-- authenticated users
protectedResources ::  Request -> IO Bool
protectedResources request = do
    let path = pathInfo request
    return $ protect path
    where protect (p : _) =  p == "admin"  -- all requests to /admin/* should be authenticated
          protect _       =  False


test1 = TestCase (assertEqual "quicksort (quicksort [0,8,9,4,6,5,1])," [0,1,4,5,6,8,9] (quicksort [0,8,9,4,6,5,1]))
test2 = TestCase (assertEqual "shift (shift [Just 4, Just 4])," [Just 8, Nothing] (shift [Just 4, Nothing]))
test3 = TestCase (assertEqual "shift' (shift' [[Just 4, Just 4], [Nothing, Nothing]])," [[Just 8, Nothing], [Nothing, Nothing]] (shift' [[Just 4, Just 4], [Nothing, Nothing]]))
test4 = TestCase (assertEqual "rotate (rotate [[Just 4, Just 4], [Nothing, Nothing]])," [[Nothing,Just 4],[Nothing,Just 4]] (rotate [[Just 4, Just 4], [Nothing, Nothing]]))
tests = TestList [TestLabel "test1" test1, TestLabel "test2" test2, TestLabel "test1" test3, TestLabel "test2" test4]


data Grid = Grid {grid :: Board} deriving (Show, Generic)
instance ToJSON Grid
instance FromJSON Grid
--data GridBD = GridBD {id:: Int, gr:: TX.Text} deriving (Show, Generic)
--instance ToJSON GridBD
--instance FromJSON GridBD
data Req = Req {sendgr:: Board, turn:: TX.Text} deriving (Show, Generic)
instance ToJSON Req
instance FromJSON Req
data Responce = Responce {sendGrid :: Board, canGo:: Bool, score::Int} deriving (Show, Generic)
instance ToJSON Responce
instance FromJSON Responce


getGrid:: Req -> [[Maybe Int]]
getGrid (Req grid _) = grid


getTurn:: Req -> TX.Text
getTurn (Req _ turn) = turn


main :: IO ()
main = do
         runTestTT tests
         --loadedConf <- C.load [C.Required "application.conf"]
         --dbConf <- makeDbConfig loadedConf
         --case dbConf of
         --      Nothing -> putStrLn "No database configuration found, terminating..."
         --      Just conf -> do
         --          pool <- createPool (newConn conf) close 1 40 10
         scotty 3000 $ do
             middleware simpleCors
             get "/" $ do
                   json (Grid createRandomStartWithoutError)
             post "/" $ do
                   req <- jsonData:: ActionM Req
                   let newGrid = (makeTurn (getGrid req) (getTurn req))::[[Maybe Int]]
                   let can = (canMakeTurn newGrid) :: Bool
                   let sc = cscore newGrid
                   json (Responce newGrid  can sc)

getReqParam :: ActionT TL.Text IO (Maybe Req)
getReqParam = do b <- body
                 return $ (Ae.decode b :: Maybe Req)

