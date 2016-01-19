#!/bin/bash -xv

# wgted_edge_gen.sh creates weighted edgelists from result.*
# and place them under yyyymmdd dirs.

homed=/home/James.P.H/UNICAGE
toold=${homed}/TOOL
shelld=${homed}/SHELL
rawd=/home/James.P.H/data
semd=/${homed}/SEMAPHORE
datad=${homed}/DATA
workd=${homed}/twitter

# TODO debug
#datad=${homed}/DATA.mini
#workd=${homed}/twitter.mini


tmp=/tmp/$$

# error function: show ERROR and exit with 1
ERROR_EXIT() {
  echo "ERROR"
  exit 1
}

mkdir -p ${workd}

# count the number of files
n=$(ls ${datad}/result.* | gyo)

for i in $(seq 1 ${n} | tarr)
do 
    # 1:Tag1 2:Tag2 3:date 4:count 
    sorter -d ${tmp}-weighted_edges_%3_${i} ${datad}/result.${i}
    [ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT
done

# listup target dates
#   /tmp/$$-weighted_edges_YYYYMMDD_i
echo ${tmp}-weighted_edges_????????_*	|
tarr					|
ugrep -v '\?'				|
sed -e 's/_/ /g'			|
self NF-1				|
msort key=1				|
uniq					> ${tmp}-datelist
# 1:date(YYYYMMDD)

[ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT

for day in $(cat ${tmp}-datelist); do
  mkdir -p ${workd}/${day}

  cat ${tmp}-weighted_edges_${day}_*	|
  # 1:word1 2:word2 3:count
  msort key=1/2				|
  sm2 1 2 3 3 				> ${workd}/${day}/weighted_edges_${day}.txt
  # 1:word1 2:word2 3:count

  [ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT

done

rm ${tmp}-*

exit 0
