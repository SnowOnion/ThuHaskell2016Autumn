module Lib2 where

import Control.Applicative
import Control.Monad.State
import System.Environment

data Option = Option {
    inPath :: String,
    outPath :: String
}
    deriving Show

type Parser a = StateT [String] Maybe a

parseFlag :: String -> Parser String
parseFlag f = do
    args <- get
    case args of
        [] -> empty
        (arg : args')
            | arg == "--" ++ f -> do
                put args'
                return f
            | otherwise -> empty
            
parseField :: String -> Parser String
parseField f = do
    parseFlag f
    args <- get
    case args of
        [] -> empty
        (arg : args') -> do
            put args'
            return arg
            
parseInPath :: Parser String
parseInPath = parseField "in"

parseOutPath :: Parser String
parseOutPath = parseField "out"

parseOption :: Parser Option
parseOption = p0 <|> p1 where
    p0 = do
        i <- parseInPath
        o <- parseOutPath
        return (Option i o)
        
    p1 = do
        o <- parseOutPath
        i <- parseInPath
        return (Option i o)

defMain :: IO ()
defMain = do
    args <- getArgs
    print $ runStateT parseOption args