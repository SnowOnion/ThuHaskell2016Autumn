module Lib4 where

import qualified Data.Map as M
import System.IO

type Env = M.Map String String

mainLoop :: Env -> IO ()
mainLoop env = do
    putStr "> "
    hFlush stdout
    l <- getLine
    case words l of
        ["set",var,val] -> do
            putStrLn (var ++ " is set to " ++ val)
            mainLoop (M.insert var val env)
        ["view",var] -> case M.lookup var env of
            Just val -> do
                putStrLn (var ++ " = " ++ val)
                mainLoop env
            Nothing -> do
                putStrLn "variable not found!"
                mainLoop env
        ["exit"] -> putStrLn "Bye~"
        _ -> do
            putStrLn "unrecognized command!"
            mainLoop env
            
defMain :: IO ()
defMain = do
    putStrLn "This is a simple REPL. Be my guest!"
    mainLoop (M.empty)