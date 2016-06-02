#!/bin/bash -xv

# compute_transition_likelihoods.sh
#

homed=/home/James.P.H/UNICAGE
toold=${homed}/TOOL
shelld=${homed}/SHELL
rawd=/home/James.P.H/data
semd=${homed}/SEMAPHORE
datad=${homed}/DATA
workd=${homed}/twitter

tmp=/tmp/$$

# TODO test
#shelld=${homed}/SHELL/sugi_test
#datad=${homed}/DATA.mini
#workd=${homed}/twitter.mini

# error function: show ERROR and delete tmp files
ERROR_EXIT() {
  echo "ERROR"
  rm -f $tmp-*
  exit 1
}

# 対象の日付リストを作成
echo ${workd}/2*				|
tarr						|
ugrep -v '\*'					|
sed -e 's/\// /g'				|
self NF						|
msort key=1					> $tmp-date-dir-list
# 1:date(real dir)

[ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT

fromdate=$(head -1 $tmp-date-dir-list)
todate=$(tail -1 $tmp-date-dir-list)

mdate -e ${fromdate} ${todate}			> $tmp-date-list
# 1:date

echo ${workd}/20??????/th*/named*_communities.txt	|
tarr						|
grep -v '\*'					|
# 1:current_filename
self 1 1					|
fsed 's#/# #2'					|
# 1:current_filename ... NF-2:current_date NF-1:"th_XX" NF:"namedXX_communities.txt"
self 1 NF-2/NF					|
# 1:current_filename 2:current_date 3:"th_XX" 4:"namedXX_communities.txt"
mdate -f 2/+1					|
# 1:current_filename 2:current_date 3:next_date 4:"th_XX" 5:"namedXX_communities.txt"
gawk '{ print $1, "'${workd}'/"$3"/"$4"/"$5 }'	|
# 1:current_filename 2:next_filename
${shelld}/intersection
## output result to "${workd}/named*_communities_transition.work"" each line.

# create map file
echo ${workd}/20??????/th*/named*_communities_transition.work	|
tarr				|
grep -v '\*'			|
while read filename; do
      # csv file name
      csv_filename=$(echo $filename | sed 's/\./ /g' | self 1/NF-1 | sed 's/ /./g' | gawk '{ print $0".csv" }')

      # create map: index=id(curr) columns=id(next)
      maezero 1.3 2.3 $filename		|
      map num=1x1 -			|
      # comvert to csv
      tocsv				> ${csv_filename}
done


# delete tmp files
rm ${workd}/20??????/th*/named*_communities_transition.work
rm -f $tmp-*

exit 0

