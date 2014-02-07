module Main where

import Numeric.Optimization.Hopty as H

main = do
  let sqrt5 = H.newton (\x -> x^2 - 5) (\x -> 2*x) 1
  let phi = H.newton (\x -> (1 + sqrt5)/2 - x) (\x -> -1) 1  -- (1 + sqrt5) / 2
  putStrLn $ "phi = " ++ show phi
