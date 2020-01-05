module Quiver.Test.Product.Elim where

import GHC.Types

import Test.Tasty
import Test.Tasty.HUnit

import Quiver.Row.Field
import Quiver.Row.Product

productElimTests :: TestTree
productElimTests = testGroup "product elim tests"
  [ test1
  , test2
  ]

fooField :: NamedField "Foo" String
fooField = Field "foo"

barField :: NamedField "Bar" String
barField = Field "bar"

fooBarPair
  :: Product
      (NamedField "Foo" String)
      (NamedField "Bar" String)
fooBarPair = Product fooField barField

barFooPair
  :: Product
      (NamedField "Bar" String)
      (NamedField "Foo" String)
barFooPair = Product barField fooField

test1 :: TestTree
test1 = testCase "getNamedRow" $ do
  assertEqual "should get value from singleton field"
    "foo" $
    getNamedRow @"Foo" fooField

  assertEqual "should get value from product field"
    "foo" $
    getNamedRow @"Foo" fooBarPair

  assertEqual "should get value from product field"
    "foo" $
    getNamedRow @"Foo" barFooPair

getFoo
  :: forall a
   . (NamedGetterField "Foo" a String)
  => a
  -> String
getFoo = getNamedRow @"Foo"

test2 :: TestTree
test2 = testCase "custom getter" $ do
  assertEqual "should get value from singleton field"
    "foo" $
    getFoo fooField

  assertEqual "should get value from product field"
    "foo" $
    getFoo fooBarPair

  assertEqual "should get value from product field"
    "foo" $
    getFoo barFooPair

getMaybeFoo
  :: forall a
   . ( NamedGetterField "Foo" a (Maybe String)
     , NamedGetterField "Bar" a String
     )
  => a
  -> String
getMaybeFoo x =
  case getNamedRow @"Foo" x of
    Just val -> val
    Nothing -> getNamedRow @"Bar" x

getFoo2
  :: forall a
   . ( NamedGetterField "Foo" a String
     , NamedGetterField "Bar" a String
     )
  => a
  -> String
getFoo2 = optionalRow @Symbol @"Foo" @a @String $ getMaybeFoo

test3 :: TestTree
test3 = testCase "optional getter" $ do
  assertEqual "should get value from product field"
    "foo" $
    getFoo2 fooBarPair

  assertEqual "should get value from product field"
    "foo" $
    getFoo2 barFooPair