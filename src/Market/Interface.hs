{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Market.Interface
    ( module Market.Interface
    , Price(..)
    , Vol(..)
    , OrderSide(..)
    , Quote(..)
    , QuoteBook(..)
    , StrategyAdvice(..)
    , Coin
    , coinSymbol
    , showBare
    , readBare
    ) where

import Data.Hashable
import Market.Types ( Price(..)
                    , Vol(..)
                    , OrderSide(..)
                    , Quote(..)
                    , QuoteBook(..)
                    , StrategyAdvice(..)
                    , Coin
                    , coinSymbol
                    , showBare
                    , readBare
                    )

---------------------------------------
-- Market/Strategy Interface

newtype ClientOID = COID Int deriving (Show, Eq, Num, Hashable)

data FillEv price vol
  = FillEv
    { fSide  :: OrderSide
    , fPrice :: Price price   -- the price that was actually used
    , fVol   :: Vol   vol     -- the volume executed in this fill
    , fCOID  :: ClientOID
    }
    deriving (Show, Eq)

data TradingEv price vol quoteTail counter
    = PlaceEv   ClientOID
    | CancelEv  ClientOID
    | DoneEv    ClientOID
    | FillsEv   [FillEv price vol]
    | BookEv    (QuoteBook price vol quoteTail counter)
    deriving (Show, Eq)

data Action price vol
    = PlaceLimit
        { aSide  :: OrderSide
        , aPrice :: Price price
        , aVol   :: Vol   vol
        , aCOID  :: ClientOID }
    | CancelLimit
        { aCOID  :: ClientOID }
    deriving (Show, Eq)

---------------------------------------
-- Strategy Control Interface

data ControlEv = ShutdownEv deriving (Show, Eq)

data ControlAction
    = ShutdownDone Int
    | Error Int String
    deriving (Show, Eq)

