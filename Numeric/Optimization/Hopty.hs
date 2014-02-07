module Numeric.Optimization.Hopty where

epsilon :: RealFloat a => a
epsilon = 1e-14

-- | Find a root of fn using the Newton-Raphson method.
newton :: RealFloat a =>
          (a -> a)  -- ^ function to find the root of
       -> (a -> a)  -- ^ derivative of given function
       -> a         -- ^ starting point for the method; should be near the root
       -> a         -- ^ the root of fn
newton fn deriv1 x
  | abs fx < epsilon = x
  | isInfinite x     = x  -- Failure: asymptotic.
  | x == nextx       = x  -- Failure to converge to required precision.
  | otherwise = newton fn deriv1 nextx
  where
    fx = fn x
    nextx = x - fx / (deriv1 x)
