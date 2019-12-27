#!/bin/bash
# Script to auto renew Lets Encrypt SSL certs based
# on defined # of valid days remaining.
# 
# Valid for Apache installs, can be easily updated to support others.
#
# Written by Drew Bentley 2019-12-27
#

# Usage: ./le_auto_renew.sh <number>
# Example: ./le_auto_renew.sh 7   # Will renew the certificates if VALID days left is less than 7 days.

# Let's extract the valid # of days left:
DAYS=`certbot certificates | grep "Expiry Date" | cut -d"(" -f2 | cut -d" " -f2`
NUM="$1"


if [ "$DAYS" -lt "$NUM" ]; then
   echo "$DAYS is less than $NUM, time to renew!"
   /usr/bin/certbot renew --quiet
   /usr/sbin/apachectl graceful   # never hurts to do a graceful restart of apache
else
   echo "$DAYS valid days is greater than $NUM day(s) configured, no need to renew yet."
fi

