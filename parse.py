import json
import pprint
import requests
file = 'output.json'
MAC_URL='http://macvendors.co/api/%s'
json_data = open(file).read()
data = json.loads(json_data)

d_mac = dict()
for x in data:
        for mac in x['_source']['layers']['eth.addr']:
                if mac != 'ff:ff:ff:ff:ff:ff':
                        if mac not in d_mac:
                                d_mac[mac] = list()
                        d_mac[mac].append(x['_source']['layers']['frame.time_relative'][0])

# we now have a dictionary with lists of the times of the packets:
# first arrival of mac's packet:
for x in d_mac:
        print 'First entry of MAC '+x+'. Time: '+d_mac[x][0]

# Last arrival of packet
for x in d_mac:
        print 'Last entry of MAC '+x+'. Time: '+d_mac[x][-1]

# Time spent:
for x in d_mac:
        print 'Time spent from MAC: '+x+'. Time on network: '+str(float(d_mac[x][-1]) - float(d_mac[x][0]))

# find out vendor:
for x in d_mac:
        r = requests.get(MAC_URL % x)
        for x in r['result']:
                print x
        #print 'MAC: '+x+'. Address:'+r['address']
        #print 'MAC: '+x+'. mac_prefix:'+r['mac_prefix']

# We can build very fancy graphs here.
# network speed
# number of new connections/second/minute
# pie chart of vendors
# activity per host/vendor
