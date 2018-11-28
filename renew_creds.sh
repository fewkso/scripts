#!/bin/bash
now=`date -u +%s`
expire=`date -d $(cat ~/.aws/credentials  | grep "x_security_token_expires" | tail -1 | awk '{print $3}') +%s`
expires_in=$(($expire-$now))

if (( $expires_in < 7200 )); then
  echo "Must re-auth!"

  saml2awslogin.sh

  if (( $? == 0 )); then
    echo "re-auth successful"
  elif (( $expires_in < 0 )); then
    echo "re-auth failed and session is expired"
    exit 1
  fi
fi 

exit 0
