#!/bin/bash

#Set up link addresses
async_ep=http://35.228.220.25:31080/
sync_ep=http://35.228.220.25:31916/allthenews?style=blackandwhite
graph_ep=https://europe-west1-ca-1-275618.cloudfunctions.net/graph


rep=4 #how many times to poll response time
sum_async=0 #sum of total repsonse time for async response time
sum_sync=0 #sum of total repsonse time for sync response time

#Curl repsonse times and get total 
for (( c=1; c<=$rep; c++ ))
do
  async=$(curl -o /dev/null -s -w %{time_total}\\n $async_ep)

  sum_async=$(echo "$sum_async + $async" | bc -l)
  
  sync=$(curl -o /dev/null -s -w %{time_total}\\n $sync_ep)

  sum_sync=$(echo "$sum_sync + $sync" | bc -l)
done

#Get averages
aveg_async=$(echo "scale=6; $sum_async/$rep" | bc -l)
aveg_sync=$(echo "scale=6; $sum_sync/$rep" | bc -l)

#Filename
timestamp=$(date +%d-%m-%Y_%H-%M-%S)
filename=response_time_$timestamp.png

plottype=bar

#JSON
template='{"filename":"%s","plottype":"%s","x":["%s", "%s"], "y":["%s", "%s"], "ylab":"%s"}'

json_string=$(printf "$template" "$filename" "$plottype" "async" "sync" "$aveg_async" "$aveg_sync" "Average Response Time")	
echo $json_string
		  
				  
# Call Google Cloud function
curl -i  -H "Accept: application/json"  -H "Content-Type:application/json" -X POST --data "$json_string"  $graph_ep