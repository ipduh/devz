#!/bin/bash
# Create README.md for devz
# g0 2014 - http://ipduh.com/contact
# http://sl.ipduh.com/devz-howto

. ./devz.sh
devz |awk 1 ORS='<br />\n'|sed 's/devz<br \/>/devz/g'|sed 's/=<br \/>/ /g' |sed 's/*/ /g' > ./README.md
