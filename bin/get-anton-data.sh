#!/bin/bash
# get register ids from tagebuecher and make a post request to anton to get the tei data only with used ids

# Usage: ./bin/get-anton-data.sh {anton_api_token}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

API_TOKEN=$1
URL=http://archives.georgfischer.com/api/tei

entities=( actors places keywords )

locale="de"

cd $SCRIPT_DIR/../src/$locale

for entity in ${entities[@]}; do
    ids=$(ack -oh "\bgfa-$entity-(\d+)\b" | uniq | sort | ack -oh '\d+'  | sed -e :a -e '$!N; s/\n/,/; ta')

    wget --post-data "ids=$ids" $URL/$entity?api_token=$API_TOKEN -O ../register/archives-$entity-$locale.xml;
done

locale="en"

cd $SCRIPT_DIR/../src/$locale

for entity in ${entities[@]}; do
    # get ids as commaseparated string
    ids=$(ack -oh "\bgfa-$entity-(\d+)\b" | uniq | sort | ack -oh '\d+'  | sed -e :a -e '$!N; s/\n/,/; ta')

    wget --post-data "ids=$ids" $URL/$entity?api_token=$API_TOKEN -O ../register/archives-$entity-$locale.xml;
done
