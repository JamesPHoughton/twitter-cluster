# Generates a properly signed URL for opening a twitter stream via curl
#
# To use, at the command prompt (or in bash)
#    URL=$(python twitter_curl_kickstarter.py)
#    curl -get "$URL"
#


import oauth2 as oauth
import time

# Set the API endpoint
url = 'https://stream.twitter.com/1.1/statuses/sample.json'

# Set the base oauth_* parameters along with any other parameters required
# for the API call.
params = {
    'oauth_version': "1.0",
    'oauth_nonce': oauth.generate_nonce(),
    'oauth_timestamp': int(time.time())
}

# Set up instances of our Token and Consumer.
token = oauth.Token(key='872256223-QSE0ftkRMIOgVGbKP8lHJLibGcr8z8bA36g9K9YV',
                    secret='FGZDSqXyieIW0nqEe4BJ6q63GF2D0vwdOsSd2cXqE')
consumer = oauth.Consumer(key='MdPm8FkpL81J48roVUP9SQ',
                          secret='q2YoANTztCFScmjkecgiPwbfSJif0aRGWJFANgnV18')

# Set our token/key parameters
params['oauth_token'] = token.key
params['oauth_consumer_key'] = consumer.key

# Create our request. Change method, etc. accordingly.
req = oauth.Request(method="GET", url=url, parameters=params)

# Sign the request.
signature_method = oauth.SignatureMethod_HMAC_SHA1()
req.sign_request(signature_method, consumer, token)

print req.to_url()
