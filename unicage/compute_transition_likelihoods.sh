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


for curr_date in $(cat $tmp-date-list); do

  next_date=$(mdate ${curr_date}/+1)

  n=0
  echo ${workd}/${curr_date}/th_*/named*_communities.txt	|
  tarr						|
  ugrep -v '\*'					|
  while read curr_filename; do
    n=$((n+1))
    echo ${curr_filename} $n

    {
      # extract end of filepath (ex: th_02/named3_communities.txt)
      tmp_next_filename=$(echo ${curr_filename} | sed -e 's/\// /g' | self NF-1/NF | sed -e 's/ /\//g')
  
      [ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT
  
      # create next_date's filepath
      next_filename=${workd}/${next_date}/${tmp_next_filename}
  
      if [ ! -s ${next_filename} ]; then
        touch ${semd}/sem.$n
        continue
      fi
  
      # create sets of tag for each community
      tarr num=1 ${curr_filename}		|
      # 1:community id 2:tag
      # exclude dupulicated tag in each community 
      msort key=1/2				|
      uniq					|
      yarr -d, num=1				> $tmp-curr_cluster.$n
      # 1:community id 2:tagset(csv)
     #  ex) 0 tag1,tag2,tag3,...
      #      1 tag1,tag3,...
      [ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT
  
      # create sets of tag for each community
      #   same as ${curr_filename}
      tarr num=1 ${next_filename}		|
      msort key=1/2				|
      uniq					|
      yarr -d, num=1				> $tmp-next_cluster.$n
      [ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT
  
      joinx $tmp-curr_cluster.$n $tmp-next_cluster.$n	> $tmp-joinx_cluster.$n
      # 1:id(curr) 2:tagset(curr) 3:id(next) 4:tagset(next)
  
      self 1 3 2 4 $tmp-joinx_cluster.$n	> $tmp-joinx_cluster_wk.$n
      # 1:id(curr) 2:id(next) 3:tagset(curr) 4:tagset(next)

##      ${shelld}/intersection $tmp-joinx_cluster_wk.$n > $tmp-intersection.$n
##      # 1:id(curr) 2:id(next) 3:tag1 .... NF:tag(NF-2)
##
##      gawk '{ print $1, $2, NF-2 }' $tmp-intersection.$n	> $tmp-likelihood.$n
##      # 1:id(curr) 2:id(next) 3:count

      ${shelld}/intersection.test $tmp-joinx_cluster_wk.$n > $tmp-likelihood.$n
      # 1:id(curr) 2:id(next) 3:count
   
      # create map: index=id(curr) columns=id(next)
      map num=1 $tmp-likelihood.$n		> $tmp-likelihood.map.$n
  
      # csv file name
      dirname=$(dirname ${curr_filename})
      mkdir -p $dirname
      csv_filename=$(basename ${curr_filename} '.txt' | gawk '{ print "'${dirname}'/"$0"_transition.csv" }')
      [ $(plus $(echo "${PIPESTATUS[@]}")) -eq "0" ] || ERROR_EXIT
  
      # comvert to csv
      tocsv $tmp-likelihood.map.$n			> ${csv_filename}

      # run 5 processes in parallel
      touch ${semd}/sem.$n
    } &

   if [ $((n % 5)) -eq 0 ]; then
     eval semwait ${semd}/sem.{$((n-4))..$n}
     eval rm ${semd}/sem.*
   fi

  done

  #semwait "${semd}/sem.*"
  eval rm ${semd}/sem.*

done


# delete tmp files
rm -f $tmp-*

exit 0

