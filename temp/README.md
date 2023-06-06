## References

- [NASA Debris Assessment Software](https://www.orbitaldebris.jsc.nasa.gov/mitigation/debris-assessment-software.html) (DAS).
- [Approximated equation](https://en.wikipedia.org/wiki/Sun-synchronous_orbit) for the SSO inclination
- Jira: [MV-166](https://axelspace.atlassian.net/browse/MV-166)

## deorbit_time.py

- This script calculates the orbit lifetime of a satellite in a circular or 
  quasi-circular SSO. 
- Nasa DAS software is used for the calculation.
- Mouse positions are read from `dict.json`.
- Use `save_pos.py` to prepare the positions.
- Positions refers to the GUI interface in DAS to calculate the orbit lifetime
  of a satellite.
- Usage: *python deorbit_time.py* `start_year`, where `start_year` is the 
  desired starting year.
- Results are saved in a file named `start_year_????.csv`, where ???? is the
  desired starting year specified in input.

## plot_by_altitude.py

- This script plots the orbit lifetime of a satellite for a specific altitude. 
- Results are read from the csv files created by `deorbit_time.py`.
- Usage: *python plot_by_altitude.py* `h`, where `h` is the desired altitude.
- The plot is also saved in `altitude=???.png`, where ??? is the desired
  altitude specified in input.

## plot_by_year.py

- This script plots the orbit lifetime of a satellite for a specific start year. 
- Results are read from the csv files created by <deorbit_time.py>.
- Usage: *python plot_by_year.py* `start_year`, where `start_year` is the 
  desired starting year.
- The plot is also saved in `start_year=????.png`, where ???? is the desired
  starting year specified in input.

## Examples

There are four examples: Parabola, Alpine, Tripod, and Ackley (see *test.py* for the specific equations and parameters). As illustration, a 3D plot of these function is shown [here](examples.bmp).

- **Parabola**, **Alpine**, and **Ackley** can have an arbitrary number of dimensions, while **Tripod** has only two dimensions.

- **Parabola**, **Tripod**, and **Ackley** are examples where parameters (respectively, array `X0`, scalars `kx` and `ky`, and array `X0`) are passed using `args`.

- The global minimum for **Parabola** and **Ackley** is at `X0`; the global minimum for **Alpine** is at zero; the global minimum for **Tripod** is at `[0,-ky]` with local minimum at `[-kx,+ky]` and `[+kx,+ky]`.
