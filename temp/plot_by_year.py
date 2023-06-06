"""
- This script plots the orbit lifetime of a satellite for a specific start year. 
- Results are read from the csv files created by <deorbit_time.py>.
- Usage: python plot_by_year.py <start_year>, where <start_year> is the 
  desired starting year.
- The plot is also saved in <start_year=????.png>, where ???? is the desired
  starting year specified in input.

References
- Jira: MV-166

by GabGil, June 2023  
"""

from matplotlib import pyplot as plt
import pandas as pd
import sys

# Format: python plot_by_year.py <start_year>
# Example: python plot_by_year.py 2024
if (len(sys.argv) == 2):
    year = sys.argv[1]

# Wrong number of arguments
else:
    print('\nUsage: python plot.py <start_year>')
    sys.exit(1)

# Read the data as dataframe
try:
    file_name = 'start_year_' + str(year) + '.csv'
    df = pd.read_csv(file_name, delimiter=',')

except:
    print('\n', file_name)
    print(' --> File not found')
    sys.exit(1)

# Plot
plt.figure(figsize=(12, 8))

# Loop over each altitude
for i in range(1, len(df.columns)):
    s=df.columns[i]
        # s = s + ',h = ' + str(h[i]) + ' km'
    label = str(s[4:-3])
    plt.plot(df['ratio'], df.iloc[:, i], 'o-', ms=3, lw=1.5)
    x = df['ratio'][0]
    y = df.iloc[0, i]
    plt.text(x, y, label, weight='bold')

# Formatting
plt.xlabel('Area-to-Mass Ratio [m$^2$/kg]', fontsize=12)
plt.ylabel('Orbit Lifetime [years]', fontsize=12)
plt.yscale("log")
plt.title('Start year = ' + year, fontsize=14, fontweight='bold')
plt.grid('visible')
plt.tight_layout()
plt.savefig('start_year=' + year + '.png')
plt.show()
