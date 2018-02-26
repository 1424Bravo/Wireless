import json

file = 'output.json'

json_data = open(file).read()
data = json.loads(json_data)

maclist = list()
time = dict()
for x in data:
        for mac in x['_source']['layers']['eth.addr']:
                if mac != 'ff:ff:ff:ff:ff:ff':
                        if mac not in maclist:
                                maclist.append(mac)
                                time[mac] = list()
                        time[mac].append(x['_source']['layers']['frame.time_relative'][0])

# we now have a dictionary with lists of the times of the packets:
# first arrival of mac's packet:
for x in time:
        print 'First entry of MAC '+x+'. Time: '+time[x][0]

# Last arrival of packet
for x in time:
        print 'Last entry of MAC '+x+'. Time: '+time[x][-1]

# Time spent:
for x in time:
        print 'Time spent from MAC: '+x+'. Time on network: '+str(float(time[x][-1]) - float(time[x][0]))

# find out vendor:
fox x in time:
        print 'MAC: '+x+'. Vendor:'

# We can build very fancy graphs here.
# network speed
# number of new connections/second/minute
# pie chart of vendors
# activity per host/vendor
