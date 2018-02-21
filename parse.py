import json

file = 'output.json'

json_data = open(file).read()
data = json.loads(json_data)

for x in data:

	print 'time_relative: '+x['_source']['layers']['frame.time_relative'][0]
	for entry in x['_source']['layers']['eth.addr']:
		print 'entry: '+entry
	print ''
