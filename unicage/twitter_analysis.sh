#!/bin/bash

homed=/home/James.P.H/UNICAGE
shelld=${homed}/SHELL
tmp=/tmp/$$

USAGE() {
  cat << EOF
  Usage: twitter_analysis.sh start_step_no end_step_no
    step_no:
      1: list_word_pairings.sh
      2: wgted_edge_gen.sh
      3: unwgted_edge_gen.sh
      4: run_mcliques.sh
      5: run_cos.sh
      6: back_to_org_words.sh
      7: compute_transition_likelihoods.sh
    ex)
      execute step4 to step6
        $ twitter_analysis.sh 4 6
      execute step2 only
        $ twitter_analysis.sh 2 2
EOF
}

if [ $# -ne 2 ]; then
  USAGE
  exit 1
fi

start=$1
end=$2
[ ${start} -gt ${end} ] && exit 1
[ ${start} -le 0 -o ${start} -ge 8 ] && exit 1
[ ${end} -le 0 -o ${end} -ge 8 ] && exit 1

# error function: show ERROR and delete tmp files
ERROR_EXIT() {
  echo "ERROR"
  rm -f $tmp-*
  exit 1
}

echo "began analysis at:" >> analysis_log.txt
echo $(date) >> analysis_log.txt

for step in $(seq ${start} ${end}); do
  echo $(date) >> analysis_log.txt
  case "${step}" in
    "1" ) echo "beginning step 1: list_word_pairings.sh" >> analysis_log.txt
          ${shelld}/list_word_pairings.sh 
          ;;
    "2" ) echo "beginning step 2: wgted_edge_gen.sh" >> analysis_log.txt
          ${shelld}/wgted_edge_gen.sh
          ;;
    "3" ) echo "beginning step 3: unwgted_edge_gen.sh" >> analysis_log.txt
          ${shelld}/unwgted_edge_gen.sh
          ;;
    "4" ) echo "beginning step 4: run_mcliques.sh" >> analysis_log.txt
          ${shelld}/run_mcliques.sh
          ;;
    "5" ) echo "beginning step 5: run_cos.sh" >> analysis_log.txt
          ${shelld}/run_cos.sh
          ;;
    "6" ) echo "beginning step 6: back_to_org_words.sh" >> analysis_log.txt
          ${shelld}/back_to_org_words.sh
          ;;
    "7" ) echo "beginning step 7: compute_transition_likelihoods.sh" >> analysis_log.txt
          ${shelld}/compute_transition_likelihoods.sh
          ;;
  esac

done
echo "analysis complete at:" >> analysis_log.txt
echo $(date)>> analysis_log.txt

rm -f $tmp-*
exit 0
