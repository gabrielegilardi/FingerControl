"""
- This script saves the positions needed by <deorbit_time.py>.
- Position the mouse where specified (never click!).
- Press 'Space' to record the position.
- Positions are saved as dictionary in the file "dict.json".
- Positions refers to the GUI interface in DAS to calculate the orbit lifetime
  of a satellite.

Reference
- Jira MV-166

by GabGil, June 2023  
"""
import json
import pyautogui as au
import keyboard as kb

dict = {}

# Position 'Reset' button
print('Reset button')
kb.wait('Space')
dict['Reset Button'] = au.position()

# Position 'Run' button
print('Run button')
kb.wait('Space')
dict['Run Button'] = au.position()

# Position 'Start Year' input
print('Start Year input')
kb.wait('Space')
dict['Start Year'] = au.position()

# Position 'Perigee Altitude' input
print('Perigee Altitude input')
kb.wait('Space')
dict['Perigee Altitude'] = au.position()

# Position 'Apogee Altitude' input
print('Apogee Altitude input')
kb.wait('Space')
dict['Apogee Altitude'] = au.position()

# Position 'Calculated Orbit Lifetime' input
print('Calculated Orbit Lifetime (close to left side of the input area)')
kb.wait('Space')
dict['Orbit Lifetime'] = au.position()

# Position 'Last year of propagation' input
print('Last year of propagation')
kb.wait('Space')
dict['Last Year'] = au.position()

# Save positions
tf = open("dict.json", "w")
json.dump(dict, tf)
tf.close
