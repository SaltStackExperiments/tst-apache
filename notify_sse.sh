#!/bin/bash


whoami

salt-call event.send build/successful

# do the initial authentication
# curl -k -c $HOME/eAPICookie.txt -u root:$SSEAPI_PASS 'https://sse.kajigga.com/version' >/dev/null

# # gather the token
# export TOKEN=$(grep -w '_xsrf' $HOME/eAPICookie.txt | cut -f7)

# # make the api call
# curl -k -u root:$SSEAPI_PASS -b $HOME/eAPICookie.txt  \
#     -H 'X-Xsrftoken: '$(grep -w '_xsrf' $HOME/eAPICookie.txt | cut -f7)'' \
#     -X POST https://sse.kajigga.com/rpc \
#     -d'{"resource": "cmd", "method": "route_cmd", "kwarg": { "cmd": "local",\
#         "job_uuid": "71ccbd4c-5377-11e6-ba39-080027a7289c",\
#         "tgt_uuid": "c19f6dd1-efc6-4164-b40e-0bf0d6549d62" }}'

