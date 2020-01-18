module Quiver.Row.Product.Cast where

import Data.Functor.Identity

import Quiver.Row.Entail
import Quiver.Row.Product.Intro
import Quiver.Row.Product.Product

castProduct
  :: forall f a b
   . ( ProductRow a
     , IntroProduct b
     , Entails
         (ProductConstraint a f Identity)
         (ProductConstraint b f Identity)
     )
  => a f
  -> b f
castProduct x =
  withProduct x $
    withEntail
      @(ProductConstraint a f Identity)
      @(ProductConstraint b f Identity) $
      introProduct @b
