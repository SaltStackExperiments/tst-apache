#!/usr/bin/env python

import sys
import os

from sseapiclient.tornado import SyncClient

print(os.environ)

client = SyncClient.connect('https://sse.kajigga.com', 'root', sys.argv[1], ssl_validate_cert=False)
print(client.api.cmd.route_cmd(cmd='local',
                               job_uuid='71ccbd4c-5377-11e6-ba39-080027a7289c',
                               tgt_uuid='c19f6dd1-efc6-4164-b40e-0bf0d6549d62').ret)
