# Benjamin Buss
# CS 1400
# December 2019
# Project 8: Was Clinton Right?

import csv
# NOTE: for ease I pre-removed the header from the BLS_corrected document

# Read in BLS data
bls_data = []
with open('C:/Users/benja/Downloads/BLS_corrected.csv', 'r') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter = ',')
    for row in csv_reader:
        year = str(row[0])
        jan = str(row[1])
        feb = str(row[2])
        mar = str(row[3])
        apr = str(row[4])
        may = str(row[5])
        jun = str(row[6])
        jul = str(row[7])
        aug = str(row[8])
        spt = str(row[9])
        oct = str(row[10])
        nov = str(row[11])
        dec = str(row[12])
        listing = [year, jan, feb, mar, apr, may, jun, jul, aug, spt, oct, nov, dec]
        bls_data.append(listing)

# Read in Presidents data
f = open("C:/Users/benja/Documents/presidents.txt", 'r')
lines = f.readlines()
lines = [line.strip() for line in lines]
f.close()

# Create arrays of the location of data per each list
pres_months = [5,7,9,11,13,15,17,19,21,23,25,27]
bls_months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

rep_jobs = 0
dem_jobs = 0

# Per Year Data
for i in range(1, 53):
    year = 1960 + i
    j = i - 1
    
    # Creates a base starting point for job creation
    if j < 1:
        bef = [0,0,0,0,0,0,0,0,0,0,0,0,45119]
    else:
        bef = bls_data[j]
    bls = bls_data[i]
    pre = lines[i]
    pre.split(" ", 1)
    
    # Run it per month
    for k in range(0, 12):
        month = k + 1
        previous = k - 1
        
        # Fetch the previous December's month data
        if previous < 1:
            mon_bef = bef[12]
        
        # Fetch the previous month's data
        else:
            mon_bef = bls[bls_months[previous]]
        
        # Get the current months value
        mon_bls = bls[bls_months[k]]
        
        # Get the party of the president in office
        mon_pre = pre[pres_months[k]] 
        
        # Compute the total change in jobs
        mon_tot = int(mon_bls) - int(mon_bef)
        
        # If democratic, add to total jobs created
        if mon_pre in ['D', 'd']:
            dem_jobs += mon_tot
        
        # Else add to republican jobs created
        else:
            rep_jobs += mon_tot
            
        # Monitoring flag for initial testing
            # Uncomment and re-run to see a monthly readout of changes
        # print("Year:", year, "Month:", month, "Change in Jobs:", mon_tot)    

# Determine the winner
if(dem_jobs > 42000):
    print("Clinton was right")
    print("Democrat Jobs  : ", dem_jobs)
    print("Republican Jobs: ", rep_jobs)
    print("Total Jobs     : ", dem_jobs + rep_jobs)
else:
    print("Clinton was wrong")
    print("Democrat Jobs  : ", dem_jobs)
    print("Republican Jobs: ", rep_jobs)
    print("Total Jobs     : ", dem_jobs + rep_jobs)
    
# Clinton was partly right, according to my analysis
# Democrats created 46,257 jobs, and Republicans created
# 26,785 jobs, with the total number of jobs being 73,042
# "Produced" is a very difficult topic to pin down when it comes
# to what effect a president can have on the Economy.
# I roughly defined "produced" as jobs created during the presidents
# tenure(which was the simplest way). However the affect of a president
# on the economy often has a lagged affect where changes made may not
# change the jobs until a year or two after they first hit/come into office.
# For example, the affect of the 2008 recession hit the democratic numbers,
# even tho the recession itself can more accurately be attributed to earlier
# republican policies
