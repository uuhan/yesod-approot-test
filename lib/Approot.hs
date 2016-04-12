{-# LANGUAGE RecordWildCards #-}
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
#ifndef USE_STATIC
import           Data.Text (Text, pack)
import           System.Environment
#endif

mkEmbeddedStatic False "eGen" [embedDir "public"]

getSite :: IO Application
getSite = do 
#ifndef USE_STATIC
    root <- pack <$> getEnv "SiteRoot"
#endif
    let getStatic = eGen
    toWaiAppPlain $ App{..}

data App = App
    { getStatic :: EmbeddedStatic
#ifndef USE_STATIC
    , root      :: Text
#endif
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
    approot = ApprootMaster root
#endif
    makeSessionBackend _ = return Nothing
