# Wireshark Assignment

Capturing is as follows:
	
  	sudo tshark -e eth.addr -e frame.time_relative -Tjson > output.json

Then run the script parse.py:

	sudo python ./parse.py

This gives some results back. At the bottom is a list of vendors and the distinctive number of MAC adresses in CSV format. Easy to make some graphs for it.

# Report
For the report, the .pdf file, latex files and presentation are added.

# NOTE!
This script assumes matlab is installed. If it is not, run the make_figs.m script manually.
