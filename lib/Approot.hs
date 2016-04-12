{-# LANGUAGE CPP #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
module Approot
    ( getSite ) 
  where

import           Yesod
import           Yesod.EmbeddedStatic

mkEmbeddedStatic False "eGen" [embedDir "public"]

getSite :: IO Application
getSite = toWaiAppPlain $ App eGen

data App = App
    { getStatic :: EmbeddedStatic
    } 

mkYesod "App" [parseRoutes|
/           HomeR   GET            
/assets     StaticR EmbeddedStatic getStatic
|]

getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
        addScript $ StaticR js_site_js
        [whamlet|
        <a href="@{HomeR}">HomeR
        |]

instance Yesod App where
#ifdef USE_STATIC
    approot = ApprootStatic "/myroot"
#else
    approot = guessApproot
#endif
    makeSessionBackend _ = return Nothing
