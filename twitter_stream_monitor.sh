#!/bin/bash
# This script starts the stream, and watches to see if it fails.
# If so, it restarts the process after some amount of time.
# The delay time increases with each attempt in case failures are due to rate limiting.

# a great description of the watchdog loop is here:
# http://stackoverflow.com/questions/696839/how-do-i-write-a-bash-script-to-restart-a-process-if-it-dies



#reconnect_delay=1
reconnect_delay=600

until ./twitter_stream_opener.sh; do
    echo "`date` Twitter curl process interrupted. Attempting reconnect after $reconnect_delay seconds"

    echo "`date` Twitter curl process interrupted. Attempting reconnect after $reconnect_delay seconds" >> tw_collect_log.txt

    sleep "$reconnect_delay"

#    if [$reconnect_delay>=600]
#    then
#        reconnect_delay=1
#    else
#        reconnect_delay=$(($reconnect_delay*2))
#    fi

done
