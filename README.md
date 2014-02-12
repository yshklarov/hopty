# Hopty

A demonstration of various optimization methods. Currently implemented:

- [Newton's method][1] in one variable
- [Gradient descent][2]
- [Pattern search][3]
- [Coordinate descent][4]
- (TODO) [Newton's method in multiple variables][5]
- (TODO) [Adaptive coordinate descent][6]
- (TODO) [Simulated annealing][7]

[1]: https://en.wikipedia.org/wiki/Newton%27s_method_in_optimization
[2]: https://en.wikipedia.org/wiki/Gradient_descent
[3]: https://en.wikipedia.org/wiki/Pattern_search_(optimization)
[4]: https://en.wikipedia.org/wiki/Coordinate_descent
[5]: https://en.wikipedia.org/wiki/Newton%27s_method_in_optimization#Higher_dimensions
[6]: https://en.wikipedia.org/wiki/Adaptive_coordinate_descent
[7]: https://en.wikipedia.org/wiki/Simulated_annealing

To run tests:

    $ cabal configure
    $ cabal build
    $ cabal haddock  # to build documentation
    $ ./dist/build/testhopty/testhopty

# Examples

## Newton's method

Calculate e very inefficiently, by finding the maximum point of ![equation][50] (unfortunately we have to find the derivatives by hand):

[50]: http://latex.codecogs.com/gif.latex?%5Csqrt%5Bx%5Dx

    *Numeric.Optimization.Hopty> let f x = x**(1/x)  -- = e^((1/x)log(x))
    *Numeric.Optimization.Hopty> let f' x = ((1/x^2) - (log x)/x^2) * f x
    *Numeric.Optimization.Hopty> let f'' x = ((1/x^2) - (log x)/x^2) * f' x + ((-2/x^3) - 1/x^2 + 2*(log x)/x^3) * f x
    *Numeric.Optimization.Hopty> newton f' f'' 1
    2.7182818284590446

This is actually inaccurate: the last two decimal places are incorrect.

## Gradient descent

Find the minimum point of the [Rosenbrock function](https://en.wikipedia.org/wiki/Rosenbrock_function), should be (1, 1):

    *Numeric.Optimization.Hopty> -- rosen [x, y] = (1-x)^2 + 100*(y-x^2)^2
    *Numeric.Optimization.Hopty> let gradrosen [x, y] = [2*(x-1) - 400*x*(y-x^2), 200*(y-x^2)]
    *Numeric.Optimization.Hopty> graddes 0.005 gradrosen [-0.5, 0.5]
    [0.9999999999999577,0.9999999999999153]

## Pattern search

This is easier to use than gradient descent: we don't need to supply the gradient! Also, it's about five times faster.

    *Numeric.Optimization.Hopty> let rosenbrock [x, y] = (1-x)^2 + 100*(y-x^2)^2
    *Numeric.Optimization.Hopty> patternsearch 100 rosenbrock [-0.5, 0.5]
    [0.9999999999973368,0.9999999999946714]

## Coordinate descent

Our coordinate descent algorithm internally performs a pattern search one coordinate at a time. For functions that aren't multiplicatively separable, it tends to zig-zag and converge very slowly. For the rosenbrock function, it takes 45 times longer than a multivariate pattern search.

    *Numeric.Optimization.Hopty> let rosenbrock [x, y] = (1-x)^2 + 100*(y-x^2)^2
    *Numeric.Optimization.Hopty> coorddes 100 rosenbrock [-0.5, 0.5]
    [0.9999999999973368,0.9999999999946714]


## Simulated annealing (TODO)

TODO: traveling salesman problem -- look up average one-way air fares between 1000 largest cities, and minimize total cost. Plot itinerary on a map.

# Issues and limitations

- Precision is not handled well (ie. at all), and arbitrary-precision calculations are not supported.
- No unit tests yet
- Poor documentation
- No detection for when convergence/divergence is too slow
