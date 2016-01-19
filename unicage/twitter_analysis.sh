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


for step in $(seq ${start} ${end}); do

  case "${step}" in
    "1" ) echo "list_word_pairings.sh"
          ${shelld}/list_word_pairings.sh 
          ;;
    "2" ) echo "wgted_edge_gen.sh"
          ${shelld}/wgted_edge_gen.sh
          ;;
    "3" ) echo "unwgted_edge_gen.sh"
          ${shelld}/unwgted_edge_gen.sh
          ;;
    "4" ) echo "run_mcliques.sh"
          ${shelld}/run_mcliques.sh
          ;;
    "5" ) echo "run_cos.sh"
          ${shelld}/run_cos.sh
          ;;
    "6" ) echo "back_to_org_words.sh"
          ${shelld}/back_to_org_words.sh
          ;;
    "7" ) echo "compute_transition_likelihoods.sh"
          ${shelld}/compute_transition_likelihoods.sh
          ;;
  esac

done

rm -f $tmp-*
exit 0
