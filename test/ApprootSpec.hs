{-# LANGUAGE OverloadedStrings #-}
module ApprootSpec
    ( main
    , spec
    ) 
  where

import           Approot
import           Test.Hspec
import           Test.Hspec.Wai

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
    describe "get /" $ with getSite $ do
        it "should response 200" $ do
            get "/" `shouldRespondWith` 200
        it "should response 200" $ do
            get "/assets/" `shouldRespondWith` 301
