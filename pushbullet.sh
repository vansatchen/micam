#!/bin/sh

# This script for send pushbullet notification with snapshot.
# Place this script to /system/sdcard/config/userscripts/motiondetection/ and insert token_id variable.
# It will run every motion detection/

token_id=""
file_name=$2

if [ "$1" == "on" ]; then
        curl_return=$(/system/sdcard/bin/curl --silent --header "Access-Token: $token_id" --header 'Content-Type: application/json' --data-binary '{"file_name":"$file_name","file_type":"image/jpeg"}' --request POST https://api.pushbullet.com/v2/upload-request)
        file_url=$(echo $curl_return | awk -F "," '{print $9}' | sed 's/"file_url"://g;s/"//g')
        upload_url=$(echo $curl_return | awk -F "," '{print $10}' | sed 's/"upload_url":"//g;s/"}//g')

        /system/sdcard/bin/curl -i -X POST $upload_url -F file=@$file_name

        ret_curl=$(/system/sdcard/bin/curl --silent --header "Access-Token: $token_id" --header 'Content-Type: application/json' --data-binary "{\"type\":\"file\",\"title\":\"Motion detected\",\"body\":\"From micam\",\"file_name\":\"$file_name\",\"file_type\":\"image/jpeg\",\"file_url\":\"$file_url\"}" --request POST https://api.pushbullet.com/v2/pushes)
fi

exit 0
