#!/bin/bash
# Script to auto renew Lets Encrypt SSL certs based
# on defined # of valid days remaining.
# 
# Valid for Apache installs, can be easily updated to support others.
#
# Written by agentpoyo 2019-12-27
# agentpoyo@gmail.com

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details. <http://www.gnu.org/licenses/>.
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

