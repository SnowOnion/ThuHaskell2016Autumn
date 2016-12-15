{-# LANGUAGE OverloadedStrings #-}

module Lib where

import Control.Applicative
import Data.Attoparsec.Text
import Data.Functor
import Data.Text

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