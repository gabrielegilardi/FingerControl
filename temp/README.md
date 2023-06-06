## References

- [NASA Debris Assessment Software](https://www.orbitaldebris.jsc.nasa.gov/mitigation/debris-assessment-software.html) (DAS).
- [Approximated equation](https://en.wikipedia.org/wiki/Sun-synchronous_orbit) for the SSO inclination
- Jira: [MV-166](https://axelspace.atlassian.net/browse/MV-166)

## deorbit_time.py

- This script calculates the orbit lifetime of a satellite in a circular or 
  quasi-circular SSO. 
- Nasa DAS software is used for the calculation.
- Mouse positions are read from *dict.json*.
- Use *save_pos.py* to prepare the positions.
- Positions refers to the GUI interface in DAS to calculate the orbit lifetime
  of a satellite.
- Usage: *python deorbit_time.py* `start_year`, where `start_year` is the 
  desired starting year.
- Results are saved in a file named *start_year_????.csv*, where ???? is the
  desired starting year specified in input.

## plot_by_altitude.py

- This script plots the orbit lifetime of a satellite for a specific altitude. 
- Results are read from the csv files created by *deorbit_time.py*.
- Usage: *python plot_by_altitude.py* `h`, where `h` is the desired altitude.
- The plot is also saved in *altitude=???.png*, where ??? is the desired
  altitude specified in input.

## plot_by_year.py

- This script plots the orbit lifetime of a satellite for a specific start year. 
- Results are read from the csv files created by *deorbit_time.py*.
- Usage: *python plot_by_year.py* `start_year`, where `start_year` is the 
  desired starting year.
- The plot is also saved in *start_year=????.png*, where ???? is the desired
  starting year specified in input.

## save_pos.py

- This script saves the positions needed by *deorbit_time.py*.
- Position the mouse where specified by the prompt (never click).
- Press 'Space' to record the position.
- Positions are saved as dictionary in the file *dict.json*.
- Positions refers to the [GUI interface in DAS](DAS_GUI_inputs.jpg) to calculate the orbit lifetime of a satellite.

## Example

In folder *Example* there are the csv files and plots obatianed for the starting years 2026, 2029, 2035, and with 
``` Python
# Area-to-Mass ratio interval
ratio = np.linspace(0.020, 0.044, 10)

# Desired altitudes to be calculated
h = np.array([600, 550, 500])
```