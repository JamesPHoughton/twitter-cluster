#!/bin/bash -xv

# unwgted_edge_gen.sh expects weighted edgelists 
# (weighted_edges_yyyymmdd.txt) located in
# /home/James.P.H/UNICAGE/twitter/yyyymmdd
# and creates unweighted edgelists under the same dir
# sorted by threshold dirs. 

homed=/home/James.P.H/UNICAGE
toold=${homed}/TOOL
shelld=${homed}/SHELL
rawd=/home/James.P.H/data
semd=${homed}/SEMAPHORE
datad=${homed}/DATA
workd=${homed}/twitter

# TODO test
#datad=${homed}/DATA.mini
#workd=${homed}/twitter.mini

tmp=/tmp/$$

# error function: show ERROR and delete tmp files
ERROR_EXIT() {
  echo "ERROR"
  rm -f $tmp-*
  exit 1
}

# setting threshold 
seq 2 15 | maezero 1.2                         > $tmp-threshold
[ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT

# creating header file
itouch "Hashtag1 Hashtag2 count" $tmp-header
[ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT

# create list for all pairs of thresholds and filenames
echo ${workd}/201[45]*/weighted_edges_*.txt          |
tarr                                                 |
joinx $tmp-threshold -                               |
# 1:threshold 2:filename
while read th wgtedges ; do
   echo ${wgtedges}
   [ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT

   # define year-month-date variable for dir and file name
   yyyymmdd=$(echo ${wgtedges} | awk -F \/ '{print $(NF-1)}')
   [ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT
   
   echo ${yyyymmdd} th_${th}
   [ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT

   # create threshold dirs under twitter/YYYYMMDD
   mkdir -p $(dirname ${wgtedges})/th_${th}
   [ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT

   cat $tmp-header ${wgtedges}                       |
   # output lines whose count feild is above thresholds
   ${toold}/tagcond '%count > '"${th}"''             | # tagcond is not working as expected, temporalily using this
   # remove threshold feild
   tagself Hashtag1 Hashtag2                         |
   # remove header
   tail -n +2                                        > ${workd}/${yyyymmdd}/th_${th}/unweighted_${yyyymmdd}_th_${th}.txt
   [ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT

done
[ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT

# delete tmp files
rm -f $tmp-*

exit 0
