#! /bin/bash

#check if log is absent and make new if needed

path_to_file="./rx_poc.log"

#checking if the log file exists and aking a new one if needed
if [ ! -e $path_to_file ]; then
	echo "log file does not exist; making new one"
	echo -e "year\tmonth\tday\thour\tobs_tmp\tfc_temp">rx_poc.log

else
	echo "appending to prexisting log file"
fi

#pull the data using curle
curl wttr.in/oakland >weather.txt 



obs_tmp=$(grep °F weather.txt | head -n 1 | tr -s " " | cut -d " " -f5)
fc_tmp=$(grep °F weather.txt | head -2 | tr -s " " | cut -d " " -f11|  sed '2p;d')


# getting the date and time in casablanca
hour=$(date -u +%H) 
day=$(date -u +%d) 
month=$(date +%m)
year=$(date +%Y)

record=$(echo -e "$year\t$month\t$day\t$hour\t$obs_tmp\t$fc_tmp")
echo $record>>rx_poc.log

