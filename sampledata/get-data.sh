#!/bin/sh

for year in {1987..2008} ; do
    FILE_NAME=${year}.csv.bz2

    if [ -e $FILE_NAME ] ; then
        echo Data file $FILE_NAME already exists. Skipping...
    else
        echo Downloading data for year $year
        wget -q http://stat-computing.org/dataexpo/2009/$FILE_NAME
    fi
done


echo Downloading list of carriers
wget -q http://stat-computing.org/dataexpo/2009/carriers.csv

echo Downloading list of airports
wget -q http://stat-computing.org/dataexpo/2009/airports.csv
