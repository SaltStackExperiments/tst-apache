#!/bin/bash

# do the initial authentication
curl -k -c $HOME/eAPICookie.txt -u root:$SSEAPI_PASS 'https://sse.kajigga.com/version' >/dev/null

# gather the token
export TOKEN=$(grep -w '_xsrf' $HOME/eAPICookie.txt | cut -f7)

# make the api call
curl -k -u root:$SSEAPI_PASS -b $HOME/eAPICookie.txt -H "X-Xsrftoken: '$TOKEN'" -X POST https://sse.kajigga.com/rpc -d'{"resource": "auth", "method": "get_all_users", "kwarg": { "config_name": "internal" }}'
