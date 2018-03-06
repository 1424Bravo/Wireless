#!/usr/bin/env python
# import matplotlib.pyplot as plot
import json
import pprint
import requests
import math
import collections
import os
in_file = 'output.json'
MAC_URL='http://macvendors.co/api/%s'
mac_file = 'vendor.csv'
first_time_file = 'connects.csv'
last_time_file = 'disconnects.csv'
time_file = 'active_time.csv'
numclients_file = 'numclients.csv'


# Do not change anything below this point!!!!
d_mac = dict()  # Dict of all mac adresses and all packet times
c_mac = dict()  # Dict of the count of all mac vendors
c_time = dict() # Dict of connect times
l_time = dict()	# Dict of leave times
a_time = dict() # Dict of time active on network
numclients = dict() # Dict with number of clients
t_max = 0

try:
	json_data = open(in_file).read()
	data = json.loads(json_data)
except:
	print 'Error reading JSON file'
	exit()
# start reading data from JSON file
for x in data:
        for mac in x['_source']['layers']['eth.addr']:
                if mac != 'ff:ff:ff:ff:ff:ff':
                        if mac not in d_mac:
                                d_mac[mac] = list()
                        d_mac[mac].append(x['_source']['layers']['frame.time_relative'][0])
                        if float(t_max) < float(x['_source']['layers']['frame.time_relative'][0]):
                        	t_max = int(math.floor(float(x['_source']['layers']['frame.time_relative'][0])))
print 'File ' + str(in_file) + ' has been read!'
# we now have a dictionary with lists of the times of the packets:
# first arrival of mac's packet:

# open file where time information has to go and write header line:
file = open(time_file, 'w')
file.write('MAC address,First time, Last time, Time on network\n')

tmp = 0
while tmp <= int(math.floor(t_max)):
	c_time[tmp] = 0
	l_time[tmp] = 0
	numclients[tmp] = 0
	tmp = tmp + 1

# Create vendor dictionary
for x in d_mac:
	# write time information to file:
	file.write(x + ',' + str(d_mac[x][0]) + ',' + str(d_mac[x][-1]) + ',' + str(float(d_mac[x][-1]) - float(d_mac[x][0]))+'\n')

	# append connect and leave time:
	time_connect = int(math.floor(float(d_mac[x][0])))
	time_leave = int(math.floor(float(d_mac[x][-1])))

	if time_connect not in c_time:
		c_time[time_connect] = 1
	else:
		c_time[time_connect] = c_time[time_connect] + 1

	if time_leave not in l_time:
		l_time[time_leave] = 1
	else:
		l_time[time_leave] = l_time[time_leave] + 1

	tmp = time_connect
	while tmp <= time_leave:
		numclients[tmp] = int(numclients[tmp] + 1)
		tmp = tmp + 1

	# find out vendor:
        r = requests.get(MAC_URL % x)

	if 'company' in r.json()['result']:
		company = r.json()['result']['company']
		address = r.json()['result']['address']
		plus = str(company)
	else:
		if 'error' in r.json()['result']:
			plus = str(r.json()['result']['error'])

	if plus not in a_time:
		a_time[plus] = list()
	# add time to an array
	a_time[plus].append(float(d_mac[x][-1]) - float(d_mac[x][0]))

	if plus not in c_mac:
		c_mac[plus] = 1
	else:
		c_mac[plus] = c_mac[plus] + 1



# Close file which now has all the time information needed:
file.close()
print 'Time information file outputted to: '+ str(time_file)

# We now have:
# 1. A CSV file with: mac, first entry, last entry, time on network
# 2. A dictionary with all vendors and the number of associated macs on the network
# 3. A dictionary with all the first entries per time unit
# 4. A dictionary with all the last entries per time unit
# 5. A variable with the latest packet time

# write vendor and number of macs to file
file = open(mac_file, 'w')
file.write('Vendor, Number of clients,Average time on network\n')
for x in c_mac:
	if x in a_time:
		str_time = str(float(sum(a_time[x])) / float(len(a_time[x])))
		print 'str_time='+str_time
	else:
		str_time = '0'
	file.write('"'+str(x) + '",' + str(c_mac[x])+','+str(str_time)+'\n')
file.close()
print 'Vendor information outputted to: '+str(mac_file)

# Write all first packet times to a file
file = open(first_time_file, 'w')
file.write('Time, Number of connects\n')
for x in c_time:
	file.write(str(x) + ',' + str(c_time[x])+'\n')
file.close()
print 'Connects per time unit information outputted to: '+str(first_time_file)

# Write all last packet times to a file
file = open(last_time_file, 'w')
file.write('T, Number of leaves\n')
for x in l_time:
	file.write(str(x) + ',' + str(l_time[x])+'\n')
file.close()
print 'Disconnects per time unit information outputted to: '+str(last_time_file)

# Print the number of clients to a file
file = open(numclients_file, 'w')
file.write('T, Number of leaves\n')
for x in numclients:
	file.write(str(x) + ',' + str(numclients[x])+'\n')
file.close()
print 'Number of active clients per time section outputted to: '+str(numclients_file)


# Run matlab script to generate figs
os.system('matlab -nodisplay -nodesktop -r "run ./make_figs.m; exit"')
