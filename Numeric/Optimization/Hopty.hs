-- |
-- Module      :  Numeric.Optimization.Hopty
-- Maintainer  :  Yakov Shklarov <yshklarov@gmail.com>

module Numeric.Optimization.Hopty
       (newton, graddes, patternsearch, coorddes)
       where

import Data.List
import Data.Ord

-- | Larger values will cause less precise results.
epsilon :: RealFloat a => a
epsilon = 1e-14

-- | Find a root of a function using the Newton-Raphson method.
newton :: RealFloat a =>
          (a -> a)  -- ^ function to find the root of
       -> (a -> a)  -- ^ derivative of given function
       -> a         -- ^ starting point for the method; should be near the root
       -> a         -- ^ the root of f
newton f deriv1 x
  | abs fx < epsilon = x  -- Success, root found.
  | isInfinite x     = x  -- Failure: asymptotic.
  | isNaN      x     = x
  | x == nextx       = x  -- Failure to converge to required precision.
  | otherwise = newton f deriv1 nextx
  where
    fx = f x
    nextx = x - fx / (deriv1 x)


-- | Find a local minimum point of a given function by the method of gradient descent.
graddes :: RealFloat a =>
           a             -- ^ Step size
        -> ([a] -> [a])  -- ^ Gradient of function
        -> [a]           -- ^ Starting point
        -> [a]           -- ^ Local minimum point
graddes gamma gradf x
  | magnitude (gradf x) < epsilon = x  -- Success, minimum point found.
  | or (map isInfinite x)         = x  -- Failure: diverged to inifinity.
  | or (map isNaN x)              = x
  | x == nextx                    = x  -- Failure to converge to required precision.
  | otherwise = graddes nextgamma gradf nextx
  where
    nextgamma = gamma * 0.99999  -- To reduce thrashing
    nextx = mapOver2 (-) x $ map (*gamma) (gradf x)


-- | Find a local minimum point of a given function by the method of coordinate descent.
coorddes :: RealFloat a =>
           a             -- ^ Initial step size
        -> ([a] -> a)    -- ^ Function to minimize
        -> [a]           -- ^ Starting point
        -> [a]           -- ^ Local minimum point
coorddes stepsize f x
  | x == nextx   = x  -- After one cycle, we're still at the same point
  | magnitude (mapOver2 subtract x nextx)
      < epsilon  = x  -- We're moving too slowly.
  | otherwise    = coorddes stepsize f nextx
  where
    nextx = foldl' minimizeByKth x [0..length x - 1]
    minimizeByKth vec k =
      replaceKth k
                 (head (patternsearch stepsize
                                      (\ [kthval] -> f (replaceKth k kthval vec))
                                      [(vec !! k)]))
                 vec


-- | Find a local minimum point of a function f : R^n -> R directly,
-- using a pattern search.
patternsearch :: RealFloat a =>
                 a           -- ^ Initial step size
              -> ([a] -> a)  -- ^ Function to minimize
              -> [a]         -- ^ Starting point
              -> [a]         -- ^ Local minimum point
patternsearch stepsize f x
  | stepsize < epsilon    = x  -- Success.
    -- FIXME: the following takes too long, is there a better way to detect it?
  | or (map isInfinite x) = x  -- Failure: diverged to infinity.
  | or (map isNaN x)      = x
  | x == nextx            = patternsearch (stepsize/2) f nextx
  | otherwise             = patternsearch stepsize f nextx
  where
    nextx = minimumBy (comparing f) $
                      x : (concatMap adjPoints [0..length x - 1])
    adjPoints k = map (\g -> applyToKth k g x)
                      [(+ stepsize), (subtract stepsize)]


-- | Find the Euclidian norm of a given vector.
magnitude :: RealFloat a => [a] -> a
magnitude = sqrt . sum . map (^2)


-- | Like map, but for a function of two arguments, the first of which is taken from
-- the first list, and the second from the second list.
mapOver2 :: (t1 -> t2 -> a) -> [t1] -> [t2] -> [a]
mapOver2 _ [] _ = []
mapOver2 _ _ [] = []
mapOver2 f (x:xs) (y:ys) = f x y : mapOver2 f xs ys


-- | Apply a function to a single element of an array. Indexed from zero.
applyToKth :: Int -> (a -> a) -> [a] -> [a]
applyToKth k f xs = take k xs
                 ++ [f (xs !! k)]
                 ++ drop (k+1) xs

-- | Replace the kth element of xs by newkth.
replaceKth :: Int -> a -> [a] -> [a]
replaceKth k newkth xs = applyToKth k (const newkth) xs
