{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Db where

import Domain
import Web.Scotty.Internal.Types (ActionT)
import GHC.Generics (Generic)
import Control.Monad.IO.Class
import Database.PostgreSQL.Simple
import Data.Pool(Pool, createPool, withResource)
import qualified Data.Text.Lazy as TL
import qualified Data.Text.Lazy.Encoding as TL
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Text as T
import GHC.Int

-- DbConfig contains info needed to connect to MySQL server
data DbConfig = DbConfig {
     dbName :: String,
     dbUser :: String,
     dbPassword :: String
     }
     deriving (Show, Generic)

-- The function knows how to create new DB connection
-- It is needed to use with resource pool
newConn :: DbConfig -> IO Connection
newConn conf = connect defaultConnectInfo
                       { connectUser = dbUser conf
                       , connectPassword = dbPassword conf
                       , connectDatabase = dbName conf
                       }


fetch :: (FromRow r, ToRow q) => Pool Connection -> q -> Query -> IO [r]
fetch pool args sql = withResource pool retrieve
      where retrieve conn = query conn sql args

-- No arguments -- just pure sql
fetchSimple :: FromRow r => Pool Connection -> Query -> IO [r]
fetchSimple pool sql = withResource pool retrieve
       where retrieve conn = query_ conn sql

-- Update database
execSql :: ToRow q => Pool Connection -> q -> Query -> IO Int64
execSql pool args sql = withResource pool ins
       where ins conn = execute conn sql args

-------------------------------------------------------------------------------
-- Utilities for interacting with the DB.
-- Transactions.
--
-- Accepts arguments
fetchT :: (FromRow r, ToRow q) => Pool Connection -> q -> Query -> IO [r]
fetchT pool args sql = withResource pool retrieve
      where retrieve conn = withTransaction conn $ query conn sql args

-- No arguments -- just pure sql
fetchSimpleT :: FromRow r => Pool Connection -> Query -> IO [r]
fetchSimpleT pool sql = withResource pool retrieve
       where retrieve conn = withTransaction conn $ query_ conn sql

-- Update database
execSqlT :: ToRow q => Pool Connection -> q -> Query -> IO Int64
execSqlT pool args sql = withResource pool ins
       where ins conn = withTransaction conn $ execute conn sql args

--------------------------------------------------------------------------------

findUserByLogin :: Pool Connection -> String -> IO (Maybe String)
findUserByLogin pool login = do
         res <- liftIO $ fetch pool (Only login) "SELECT * FROM users WHERE login=?" :: IO [(Integer, String, String)]
         return $ password res
         where password [(_, _, pwd)] = Just pwd
               password _ = Nothing

--------------------------------------------------------------------------------

findGrid :: Pool Connection -> TL.Text -> IO (Maybe GridBD)
findGrid pool id = do
     res <- fetch pool (Only id) "SELECT * FROM grids WHERE id=?" :: IO [(Int, TL.Text)]
     return $ oneGrid res
     where oneGrid ((id, gr) : _) = Just (GridBD id gr)
           oneGrid _ = Nothing


insertGrid :: Pool Connection -> Maybe GridBD -> ActionT TL.Text IO ()
insertGrid pool Nothing = return ()
insertArticle pool (Just (GridBD id gr)) = do
     liftIO $ execSqlT pool [gr]
                            "INSERT INTO grids(gr) VALUES(?)"
     return ()

updateGrid :: Pool Connection -> Maybe GridBD -> ActionT TL.Text IO ()
updateGrid pool Nothing = return ()
updateArticle pool (Just (GridBD id gr)) = do
     liftIO $ execSqlT pool [gr, (TL.decodeUtf8 $ BL.pack $ show id)]
                            "UPDATE grids SET gr=? WHERE id=?"
     return ()