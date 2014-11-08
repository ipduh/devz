#!/bin/bash
# Create README.md for devz
# g0 2014 - http://ipduh.com/contact
# http://sl.ipduh.com/devz-howto

README='./README.md'

. ./devz.sh
echo "devz" > $README
echo "====" >> $README
devz |awk 1 ORS='<br />\n' >> $README
