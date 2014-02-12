module Main where

import qualified Numeric.Optimization.Hopty as H

main = do
--  putStrLn $ "phi (should be ~1.618) = " ++ show phi
  putStrLn $ "Minimum point of Rosenbrock function (should be [1, 1]):"
  putStrLn $ "By gradient descent:   " ++ show minrosenGraddes
  putStrLn $ "By pattern search:     " ++ show minrosenPatternsearch
  putStrLn $ "By coordinate descent: " ++ show minrosenCoorddes


-- Golden ratio
sqrt5 = H.newton (\x -> x^2 - 5) (\x -> 2*x) 1
phi = H.newton (\x -> (1 + sqrt5)/2 - x) (\x -> -1) 1  -- (1 + sqrt5) / 2

-- Rosenbrock function
rosen [x, y] = (1-x)^2 + 100*(y-x^2)^2
gradrosen [x, y] = [2*(x-1) - 400*x*(y-x^2),
                    200*(y-x^2)]
minrosenGraddes = H.graddes 0.005 gradrosen [-0.5, 0.5]
minrosenPatternsearch = H.patternsearch 1 rosen [-0.5, 0.5]
minrosenCoorddes = H.coorddes 1 rosen [-0.5, 0.5]
