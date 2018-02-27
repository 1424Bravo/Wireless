# Wireless
This page is for the wireshark assignment.

Capturing is as follows:
	
	sudo tshark -e eth.addr -e frame.time_relative -Tjson > output.json


Then run the script parse.py:

	sudo python ./parse.py

This gives some results back. At the bottom is a list of vendors and the distinctive number of MAC adresses in CSV format. Easy to make some graphs for it.
