{-# OPTIONS_GHC -O -ddump-rule-firings -dsuppress-all -fforce-recomp -Wall #-}
{-# LANGUAGE ScopedTypeVariables #-}

-- small test binary to see if the rules get fired,
-- they do
module Main where

import GHC.Word
import Data.Word.Word24

-- A wrapper we control so a rule can reliably match
fromIntegralW8 :: Word8 -> Word24
fromIntegralW8 = fromIntegral
{-# INLINE fromIntegralW8 #-}

-- This one should FIRE (uses the wrapper)
foo :: Word8 -> Word24
foo x = fromIntegralW8 x
{-# NOINLINE foo #-}

-- This one probably WON'T FIRE (plain fromIntegral)
bar :: Word8 -> Word24
bar x = fromIntegral x
{-# NOINLINE bar #-}

main :: IO ()
main = do
  print (foo 7)
  print (bar 7)
