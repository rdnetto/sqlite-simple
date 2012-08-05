{-# LANGUAGE RecordWildCards, DeriveDataTypeable, GeneralizedNewtypeDeriving #-}
------------------------------------------------------------------------------
-- |
-- Module:      Database.SQLite.Simple.Internal
-- Copyright:   (c) 2011-2012 Leon P Smith
-- License:     BSD3
-- Maintainer:  Leon P Smith <leon@melding-monads.com>
-- Stability:   experimental
-- Portability: portable
--
-- Internal bits.  This interface is less stable and can change at any time.
-- In particular this means that while the rest of the postgresql-simple
-- package endeavors to follow the package versioning policy,  this module
-- does not.  Also, at the moment there are things in here that aren't
-- particularly internal and are exported elsewhere;  these will eventually
-- disappear from this module.
--
------------------------------------------------------------------------------

module Database.SQLite.Simple.Internal where

import Prelude hiding (catch)

import           Control.Applicative
import           Control.Exception
import           Control.Concurrent.MVar
import           Data.ByteString(ByteString)
import qualified Data.ByteString       as B
import qualified Data.ByteString.Char8 as B8
import           Data.Char (ord)
import           Data.Int (Int64)
import qualified Data.IntMap as IntMap
import           Data.String
import           Data.Typeable
import           Data.Word
import           Control.Monad.Trans.State.Strict
import           Control.Monad.Trans.Reader
import qualified Data.Vector as V
import           System.IO.Unsafe (unsafePerformIO)

import           Database.SQLite.Simple.Ok
import qualified Database.SQLite3 as Base

-- | A Field represents metadata about a particular field
--
-- You don't particularly want to retain these structures for a long
-- period of time,  as they will retain the entire query result,  not
-- just the field metadata

data Field = Field {
     result   :: Base.SQLData
   , column   :: {-# UNPACK #-} !Int
--   , typename :: !ByteString
   }

data Row = Row {
     row        :: {-# UNPACK #-} !Int
   , typenames  :: !(V.Vector ByteString)
--   , rowresult  :: !PQ.Result
   }

newtype RowParser a = RP { unRP :: ReaderT Row (StateT Int Ok) a }
   deriving ( Functor, Applicative, Alternative, Monad )

--getvalue :: PQ.Result -> PQ.Row -> PQ.Column -> Maybe ByteString
--getvalue result row col = unsafePerformIO (PQ.getvalue result row col)

--nfields :: PQ.Result -> PQ.Column
--nfields result = unsafePerformIO (PQ.nfields result)
