{-# LANGUAGE OverloadedStrings #-}
module Main
  where

import           Approot
import           Warp (runSettings, defaultSettings, setPort, setHost)

import           GHC.IO
import           Control.Concurrent
import           Control.Monad (unless, void)
import           System.Process as P
import           System.Directory
import           System.FilePath ((</>))
import           System.Posix
import           System.Exit

{-# INLINE dir #-}
dir = unsafePerformIO getCurrentDirectory

main :: IO ()
main = do 
    mid <- myThreadId
    wid <- forkIO $ getSite >>= \site -> runSettings (setPort 4000 . setHost "127.0.0.1" $ defaultSettings) site
    nid <- forkIO $ void $ stop >> P.rawSystem "nginx" ["-p", dir, "-c", "nginx.conf"]
    installHandler keyboardSignal (Catch (newline >> quit [wid, nid] >> stop >> throwTo mid ExitSuccess)) Nothing
    loop
  where
    quit :: [ThreadId] -> IO ()
    quit [] = return ()
    quit (x:xs) = do 
        putStrLn $ "Kill Thread: " ++ show x
        killThread x 
        quit xs
    newline = putStrLn "\n"
    stop = void $ P.rawSystem "nginx" ["-p", dir, "-c", "nginx.conf", "-s", "stop"]
    loop = threadDelay 1000 >> loop
