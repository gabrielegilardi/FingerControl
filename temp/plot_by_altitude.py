"""
- This script plots the orbit lifetime of a satellite for a specific altitude. 
- Results are read from the csv files created by <deorbit_time.py>.
- Usage: python plot_by_altitude.py <h>, where <h> is the desired altitude.
- The plot is also saved in <altitude=???.png>, where ??? is the desired
  altitude specified in input.

References
- Jira: MV-166

by GabGil, June 2023  
"""

import numpy as np
from matplotlib import pyplot as plt
import pandas as pd
import sys

# Year range
start_year = [2026, 2029, 2035]

# Format: python plot_by_altitude.py <h>
# Example: python plot_by_altitude.py 600
if (len(sys.argv) == 2):
    h = sys.argv[1]

# Wrong number of arguments
else:
    print('\nUsage: python plot_by_altitude.py <h>')
    sys.exit(1)

# Format as should be in the csv file
col = 'h = ' + str(h) + ' km'

# Plot
plt.figure(figsize=(12, 8))

# Read and plot data for all the starting years in the file
for i in range(len(start_year)):
    file_name = 'start_year_' + str(start_year[i]) + '.csv'

    # Read the data as dataframe
    try:
        df = pd.read_csv(file_name, delimiter=',')

    except:
        print('\n', file_name)
        print(' --> File not found')
        sys.exit(1)

    # Check if the column exists
    if (col not in df.columns):
        print('\n', file_name)
        print(' --> column', col, 'not found')
        sys.exit(1)

    # Plot the data
    label = str(start_year[i])
    plt.plot(df['ratio'], df[col], '-o', ms=3, lw=1.5)
    x = df['ratio'][0]
    y = df[col][0]
    plt.text(x, y, label, weight='bold')

# Formatting
plt.xlabel('Area-to-Mass Ratio [m$^2$/kg]', fontsize=12)
plt.ylabel('Orbit Lifetime [years]', fontsize=12)
plt.title(col, fontsize=14, fontweight='bold')
plt.grid('visible')
plt.tight_layout()
plt.savefig('altitude=' + str(h) + '.png')
plt.show()
