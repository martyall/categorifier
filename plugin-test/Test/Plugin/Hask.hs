{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

module Test.Plugin.Hask
  ( Hask (..),
  )
where

import qualified Control.Arrow as Base
import qualified Control.Category as Base
import Kitty.Plugin.Category (ReferenceCat (..), RepCat (..))
import qualified Kitty.Plugin.Client as Client

-- | A trivial wrapper around __Hask__ for testing purposes.
data Hask a b = Hask {runHask :: a -> b}
{-# ANN Hask "Hlint: ignore Use newtype instead of data" #-}

instance Base.Category Hask where
  id = Hask Base.id

  Hask f . Hask g = Hask (f Base.. g)

instance Base.Arrow Hask where
  arr = Hask

  first (Hask f) = Hask (Base.first f)

instance Base.ArrowApply Hask where
  app = Hask (Base.app . Base.first runHask)

instance Base.ArrowChoice Hask where
  Hask f +++ Hask g = Hask (f Base.+++ g)

instance Base.ArrowLoop Hask where
  loop (Hask f) = Hask (Base.loop f)

instance (Client.HasRep a, r ~ Client.Rep a) => RepCat Hask a r where
  abstC = Hask Client.abst
  reprC = Hask Client.repr

instance ReferenceCat Hask a b
