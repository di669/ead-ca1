
async_ep=http://35.228.220.25:31080/
graph_ep=https://europe-west1-ca-1-275618.cloudfunctions.net/graph

door1="../Async/manifestsdeployment_d1.yaml"
door2="../Async/manifestsdeployment_d2.yaml"
door3="../Async/manifestsdeployment_d3.yaml"

gcloud container clusters get-credentials ead2 --zone europe-north1-a --project ca-1-275618

arr=( $(kubectl get pods) )
#pods=`kubectl get pods`

echo $pods

timestamp=$(date +%d-%m-%Y_%H-%M-%S)
filename=aync_response_time_$timestamp.png

plottype=line

template='{"filename":"%s","plottype":"%s","x":["%s", "%s"], "y":["%s", "%s"], "ylab":"%s"}'

json_string=$(printf "$template" "$filename" "$plottype" "async" "sync" "$aveg_async" "$avers" "Average Response Time")	
#echo $json_string
		  
				  
# Call Google Cloud function to create graph
#curl -i \
 #     -H "Accept: application/json" \
  #    -H "Content-Type:application/json" \
   #   -X POST --data "$json_string"  $graph_ep