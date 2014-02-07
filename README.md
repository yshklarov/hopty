# Hopty

A demonstration of various optimization methods. Currently implemented:

- [Newton's method](https://en.wikipedia.org/wiki/Newton%27s_method_in_optimization) in one variable
- (TODO) Gradient descent
- (TODO) Newton's method in multiple variables
- (TODO) [Simulated annealing](https://en.wikipedia.org/wiki/Simulated_annealing)

To run tests:

    $ cabal configure
    $ cabal build
    $ cabal haddock  # to build documentation
    $ ./dist/build/testhopty/testhopty

# Examples

Newton's method: Calculate e very inefficiently, by finding the maximum point of f(x) = x^(1/x): (unfortunately we have to find the derivatives by hand)

    *Numeric.Optimization.Hopty> let f x = x**(1/x)  -- = e^((1/x)log(x))
    *Numeric.Optimization.Hopty> let f' x = ((1/x^2) - (log x)/x^2) * fn x
    *Numeric.Optimization.Hopty> let f'' x = ((1/x^2) - (log x)/x^2) * fn' x + ((-2/x^3) - 1/x^2 + 2*(log x)/x^3) * fn x
    *Numeric.Optimization.Hopty> newton f' f'' 1
    2.718281828458931

This is actually inaccurate: it is only correct to the 11th decimal place.

TODO: with simulated annealing: traveling salesman problem -- look up average one-way air fares between 1000 largest cities, and minimize total cost. Plot itinerary on a map.

# Issues and limitations

- Precision is not handled well (ie. at all), and arbitrary-precision calculations are not supported.
- No unit tests yet
- Poor documentation
