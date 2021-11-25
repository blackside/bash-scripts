#!/bin/bash
#

# Loop through all namespaces except BLACKLIST and get pods with previous state OOM
# Print image name and pods state

NSBLACKLIST='NAME|cattle|system|kube|ingress|fleet|security'

for n in $(kubectl get namespaces | awk '{print $1}' | egrep -iv "${NSBLACKLIST}" )
    do
      result=$(kubectl describe pods -n ${n} 2> /dev/null | grep -B10  OOM | grep "Image:" )
      images=$(printf "${result}" | sort -u | sed 's/.*\/\(.*\):.*/\1/')
      #echo "Content of images ${images}"
      if [ -n "${result}" ];
      then
        echo "In namespace: ${n}" 
        for i in ${images}
          do
            echo "Image: ${i}"
            kubectl get pods -n ${n} | grep ${i}
          done
      fi
done
