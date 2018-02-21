#!/bin/bash

# This script parses the output file
file='output.json'
macs=`cat $file | grep 'eth.addr' | sed -e 's/.*\[//' | sed -e 's/\].*//' | sed -e 's/\"//g' | sed -e 's/$/,/' | tr -d \\\n`
macs=`echo $macs | sed -e 's/,$//'`
#echo $macs



OLDIFS=$IFS
IFS=,
#[ ! -f $macs ] && { echo "$INPUT file not found"; exit 99; }
while read mac
do
	echo "MAC : $mac"
done < $macs
IFS=$OLDIFS

