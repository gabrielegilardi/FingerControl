"""
- This script calculates the orbit lifetime of a satellite in a circular or 
  quasi-circular SSO. 
- Nasa DAS software is used for the calculation.
- Mouse positions are read from <dict.json>.
- Use <save_pos.py> to prepare the positions.
- Positions refers to the GUI interface in DAS to calculate the orbit lifetime
  of a satellite.
- Usage: python deorbit_time.py <start_year>, where <start_year> is the 
  desired starting year.
- Results are saved in a file named <start_year_????.csv>, where ???? is the
  desired starting year specified in input.

References
- NASA Debris Assessment Software (DAS).
- Jira: MV-166

by GabGil, June 2023  
"""
import numpy as np
import pyautogui as au
import pyperclip as clip
import sys
import json


def solve(ratio, dict, start_year):
    """
    Returns the calculation for one set of parameters.
    """
    # Input "Area-to-mass" ratio
    au.doubleClick()
    au.write(str(ratio))

    # Run computation ("Run" button)
    au.moveTo(dict['Run Button'])
    au.click()

    # Copy result from "Calculated Orbit Lifetime" to the clipboard
    au.moveTo(dict['Orbit Lifetime'])
    au.doubleClick()
    au.keyDown('ctrl')
    au.press('c')     
    au.keyUp('ctrl')

    # Get the result from the clipboard
    s = clip.paste()

    # If it is the word "Greater", copy the result from "Last year of propagation"
    # and subtract the current start year
    if (s[0] == 'G'):
        au.moveTo(dict['Last Year'])
        au.doubleClick()
        au.keyDown('ctrl')
        au.press('c')     
        au.keyUp('ctrl')
        s = clip.paste()
        x = float(s) - float(start_year)

    # Convert the result to number
    else:
        x = float(s)

    return x


#===== Main

# Format: python deorbit_time.py <start_year>
# Example: python deorbit_time.py 2024
if (len(sys.argv) == 2):
    start_year = sys.argv[1]

# Wrong number of arguments
else:
    print('\nUsage: python deorbit_time.py <start_year>')
    sys.exit(1)

# Area-to-Mass ratio interval
ratio = np.linspace(0.020, 0.044, 10)

# Desired altitudes to be calculated
h = np.array([600, 550, 500])

# Read the dictionary with the positions
tf = open("dict.json", "r")
dict = json.load(tf)
tf.close

# Parameters
n_ratio = len(ratio)
n_h = len(h)
data = np.zeros((n_h, n_ratio))
delta = dict['Apogee Altitude'][1] - dict['Perigee Altitude'][1]

# Reset
au.moveTo(dict['Reset Button'])
au.click()

# Input "Start Year"
au.moveTo(dict['Start Year'])
au.click()
au.write(str(start_year))

# Loop over the altitudes
for j in range(n_h):

    # SSO inclination [deg]
    cos_i = - ((6378 + h[j]) / 12352) ** 3.5
    incl = np.degrees(np.arccos(cos_i))

    # Input "Perigee Altitude"
    au.moveTo(dict['Perigee Altitude'])
    au.doubleClick()
    au.write(str(h[j]))

    # Input "Apogee Altitude"
    au.moveTo(dict['Apogee Altitude'])
    au.doubleClick()
    au.write(str(h[j]))

    # Input "Inclination"
    au.move(0, delta)
    au.doubleClick()
    au.write(str(incl))

    # Input "RAAN" (always set to zero)
    au.move(0, delta)
    au.doubleClick()
    au.write(str(0))

    # Input "Argument of perigee" (always set to zero)
    au.move(0, delta)
    au.doubleClick()
    au.write(str(0))

    # Take the "Area-to-Mass" ratio as reference point
    au.move(0, delta)
    refA2m = au.position()

    # Loop over the area-to-mass ratio
    for i in range(n_ratio):
        data[j, i] = solve(ratio[i], dict, start_year)
        au.moveTo(refA2m)

    # Next altitude
    au.moveTo(dict['Start Year'])

# Add area-to-mass ratio column of values
data = np.concatenate((ratio.reshape(-1, 1), data.T), axis=1)

# Build column names
s = 'ratio'
for i in range(len(h)):
    s = s + ',h = ' + str(h[i]) + ' km'

#  Save
np.savetxt('start_year_' + str(start_year) + '.csv', data, delimiter=',',
           header=s, comments='')
