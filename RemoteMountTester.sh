#!/bin/ksh
file_contents=`cat test_text.txt`
for line in $(cat directories.conf | sed 's/ /#/g') #treating spaces on the directories
do
    final_line=`echo $line | sed 's/#/ /g'`
    test_file="$final_line/test_file.txt"
    rm -rf "$test_file"
    
    real_time=`{ time echo $file_contents > $test_file; } 2>&1 | grep real | awk '{ print $2 }'`

    minutes=`{ IFS='m'; echo $real_time | awk '{ print $1 }'; }`
    seconds=`{ IFS='m'; echo $real_time | awk '{ print $2 }' | sed 's/s//g'; }`
    
    seconds_milis=`echo "$seconds * 1000" | bc`
    seconds_milis=`{ IFS='.'; echo $seconds_milis | awk '{ print $1 }'; }`
    minutes_milis=`echo "$minutes * 60 * 1000" | bc`
    let time_milis=minutes_milis+seconds_milis
    
    if [[ -e "$test_file" ]]; then #file exists so lets print the metric
        echo "name=Custom Metrics|Mount point availability|$final_line|avg write time (ms),value=$seconds_milis,aggregator=AVG"
        echo "name=Custom Metrics|Mount point availability|$final_line|succsessful file creation,value=1,aggregator=AVG"
        rm -rf "$test_file"
        if [[ -e "$test_file" ]]; then
            echo "name=Custom Metrics|Mount point availability|$final_line|failed file deletion,value=1,aggregator=AVG"
        else
            echo "name=Custom Metrics|Mount point availability|$final_line|successful file deletion,value=1,aggregator=AVG"
        fi
    else
        echo "name=Custom Metrics|Mount point availability|$final_line|failed file creation,value=1,aggregator=AVG"
    fi
done