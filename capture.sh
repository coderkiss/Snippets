#/bin/bash

deviceList=();

while read LINE;
do
    if [ -n "$LINE" ] && [ "`echo $LINE | awk '{print $2}'`" == "device" ]
    then
        serial="`echo $LINE | awk '{print $1}'`"
        model="$(adb -s $serial shell getprop ro.product.model)"
        deviceList+=("$serial $model")
        #echo "$serial $model"
    fi
done <<<"$(adb devices)"


selected="";

count=${#deviceList[@]}
if [[ "$count" -eq 0 ]]; then
	exit 0;
elif [[ "$count" -eq 1 ]]; then
	selected=${deviceList[0]}
else
	select opt in "${deviceList[@]}"
	do
	    case $opt in
	        *)
			if [[ " ${deviceList[@]} " =~ " ${opt} " ]]; then
				selected=$opt;
			fi
			break;
			;;
	    esac
	done
fi

serial="`echo $selected | awk '{print $1}'`"
model="`echo $selected | awk '{print $2}'`"


fileName=$(date +"%Y-%m-%d_%H.%M.%S.png");
echo "capture from $serial > $fileName";

adb -s $serial shell screencap -p /sdcard/screencap.png;
adb -s $serial pull /sdcard/screencap.png $fileName;
