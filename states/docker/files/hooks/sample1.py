#!/usr/bin/env python
# Python Example for Python GitHub Webhooks
# File: push-myrepo-master

import sys
import json

if __name__ == "__main__":
    with open(sys.argv[1], 'r') as jsf:
        payload = json.loads(jsf.read())

    # Do something with the payload
    name = payload['repository']['name']
    outfile = '/tmp/hook-{}.log'.format(name)

    with open(outfile, 'w') as f:
        f.write(json.dumps(payload))