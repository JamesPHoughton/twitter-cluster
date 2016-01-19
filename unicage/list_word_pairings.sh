#!/bin/bash

homed=/home/James.P.H/UNICAGE
toold=${homed}/TOOL
shelld=${homed}/SHELL
rawd=/home/James.P.H/data
semd=${homed}/SEMAPHORE
datad=${homed}/DATA
workd=${homed}/twitter

mkdir -p ${datad}

n=0

# Process zipped files/
echo ${rawd}/posts_sample*.gz                                          |
tarr                                                                   |
while read zipfile; do         
  n=$((n+1))
  echo $zipfile $n

  {
    zcat $zipfile                                                        |
    jq -c '{time: .timestamp_ms, hashtag: [.entities.hashtags[]?.text]}' |
    grep "time"                                                          |
    grep "hashtag"                                                       |
    grep -v ':null'                                                         |
    tr -d '{}[] '                                                        |
    tr ':' ','                                                           |
    fromcsv                                                              |
    # 1: "time" 2: timestamp (epoch msec) 3: "hashtag" 4-N: hashtags

    awk 'NF>5{for(i=4;i<=NF;i++)for(j=i+1;j<=NF;j++){print $i,$j,int($2/1000)}}' |
    # list all possible 2 word combinations with timestamp. 1: word1 2: word2 3: timestamp (epoch sec)

    calclock -r 3                                                        |
    # 1: word1 2: word2 3: timestamp (epoch sec) 4: timestamp (YYYYMMDDhhmmss)

    self 1 2 4.1.8                                                       |
    # 1: word1 2: word2 3: timestamp (YYYYMMDD)

    msort key=1/3                                                        | 
    count 1 3                                                            > ${datad}/result.$n
    # count lines having the same word combination and timestamp 1:word1 2:word2 3:date 4:count

    # run 5 processes in parallel
    touch ${semd}/sem.$n
   } &
   if [ $((n % 5)) -eq 0 ]; then
     eval semwait ${semd}/sem.{$((n-4))..$n}
     eval rm ${semd}/sem.*
   fi
done

wait

n=$(ls ${datad}/result.* | sed -e 's/\./ /g' | self NF | msort key=1n | tail -1)

# Process unzipped files.
#    *There are unzipped files in raw data dir(/home/James.P.H/data).
echo ${rawd}/posts_sample*						|
tarr									|
self 1 1.-3.3								|
delr 2 '.gz'								|
self 1									|
while read nozipfile; do         
  n=$((n+1))
  echo $nozipfile $n

  {
    cat $nozipfile                                                       |
    jq -c '{time: .timestamp_ms, hashtag: [.entities.hashtags[]?.text]}' |
    grep "time"                                                          |
    grep "hashtag"                                                       |
    grep -v ':null'                                                      |
    tr -d '{}[] '                                                        |
    tr ':' ','                                                           |
    fromcsv                                                              |
    # 1: "time" 2: timestamp (epoch msec) 3: "hashtag" 4-N: hashtags

    awk 'NF>5{for(i=4;i<=NF;i++)for(j=i+1;j<=NF;j++){print $i,$j,int($2/1000)}}' |
    # list all possible 2 word combinations with timestamp. 1: word1 2: word2 3: timestamp (epoch sec)

    calclock -r 3                                                        |
    # 1: word1 2: word2 3: timestamp (epoch sec) 4: timestamp (YYYYMMDDhhmmss)

    self 1 2 4.1.8                                                       |
    # 1: word1 2: word2 3: timestamp (YYYYMMDD)

    msort key=1/3                                                        | 
    count 1 3                                                            > ${datad}/result.$n
    # count lines having the same word combination and timestamp 1:word1 2:word2 3:date 4:count

    # run 5 processes in parallel
    touch ${semd}/sem.$n
   } &
   if [ $((n % 5)) -eq 0 ]; then
     eval semwait ${semd}/sem.{$((n-4))..$n}
     eval rm ${semd}/sem.*
   fi
done

#semwait "${semd}/sem.*"
wait
eval rm ${semd}/sem.*

exit 0

