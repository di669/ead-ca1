

deployments=($( kubectl get deployments | awk '{print $1}' | awk  'BEGIN { ORS=" " }; {if(NR>1)print}'))
word=" this is a story"
arr=$(echo $deployments | tr "\n" "\n")
echo "before"
echo $deployments

for x in $deployments
do
    echo "\"$x\""
	echo "hi"
done

#'BEGIN { ORS=" " };