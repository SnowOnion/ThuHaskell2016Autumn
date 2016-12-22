{-# LANGUAGE OverloadedStrings #-}
-- 若在 ghci 中执行，需 :set -XOverloadedStrings

module Lib where

import Control.Applicative
import Data.Attoparsec.Text
import Data.Functor

data Expr
    = FalseLit
    | TrueLit
    | Not Expr
    | And Expr Expr
    | Or Expr Expr
    deriving Show
    
exprParser :: Parser Expr
exprParser = falseParser <|> trueParser <|> notParser

falseParser :: Parser Expr
falseParser = lexeme $ string "False" $> FalseLit

trueParser :: Parser Expr
trueParser = lexeme $ string "True" $> TrueLit

notParser :: Parser Expr
notParser = do
    lexeme $ char '('
    lexeme $ string "not"
    expr <- exprParser
    lexeme $ char ')'
    return (Not expr)
    
lexeme :: Parser a -> Parser a
lexeme p = do
    skipSpace
    p

eval :: Expr -> Bool
eval FalseLit = False
eval TrueLit = True
eval (Not p) = not $ eval p
-- eval (And p q) =  
-- eval (Or p q) =  

-- designed for parseOnly
--   :: Data.Attoparsec.Text.Parser a
--      -> Data.Text.Internal.Text -> Either String a
evalWithErrorThrowing :: Either String Expr -> String
evalWithErrorThrowing (Left errStr) = "not a valid bool expr: " ++ errStr
evalWithErrorThrowing (Right expr) = show $ eval expr

defMain :: IO ()
defMain = do
    putStrLn $ show $ parseOnly notParser "(not True)"
    putStrLn $ show $ parse notParser "(not True)"
    putStrLn "-------"
    putStrLn $ show $ parseOnly notParser "(nXXX True)"
    putStrLn $ show $ parse notParser "(nXXX True)"
    putStrLn "-------"
    putStrLn $ show $ parseOnly notParser "(not Tr"
    putStrLn $ show $ parse notParser "(not Tr"
    putStrLn "-------"
    putStrLn $ show $ parseOnly notParser "(not True)   MORE"
    putStrLn $ show $ parse notParser "(not True)   MORE"
    putStrLn "--------------"
    putStrLn $ show $ parseOnly exprParser "(not True)"
    putStrLn $ show $ parse exprParser "(not True)"
    putStrLn "-------"
    putStrLn $ show $ parseOnly exprParser "(nXXX True)"
    putStrLn $ show $ parse exprParser "(nXXX True)"
    putStrLn "-------"
    putStrLn $ show $ parseOnly exprParser "(not Tr"
    putStrLn $ show $ parse exprParser "(not Tr"
    putStrLn "-------"
    putStrLn $ show $ parseOnly exprParser "(not True)   MORE"
    putStrLn $ show $ parse exprParser "(not True)   MORE"
    putStrLn "--------------"
    putStrLn $ show $ evalWithErrorThrowing $ parseOnly exprParser "(not True)"
    putStrLn $ show $ evalWithErrorThrowing $ parseOnly exprParser "(not Tr"
    putStrLn $ show $ evalWithErrorThrowing $ parseOnly exprParser "(nXXX True)"
    putStrLn $ show $ evalWithErrorThrowing $ parseOnly exprParser "(not True)   MORE"
