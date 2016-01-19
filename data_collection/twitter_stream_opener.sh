#!/bin/bash
# This script starts a curl process to get posts from twitter and saves them to 100000 post long files

# The python libraries for handling oauth are much better than what is available in bash,
# so we'll use them to return a valid url string


URL=$(python twitter_curl_url_builder.py)

curl --get "$URL" | split -l 100000 - ./raw/posts_sample_`date "+%Y%m%d_%H%M%S"`_

echo "`date` Twitter stream broken with error: ${PIPESTATUS[0]}" >> tw_collect_log.txt

# the curl should go on indefinitely, so if we get to this point, an error has occurred, raise a nonzero flag
exit 1
