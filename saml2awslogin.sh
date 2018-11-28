#!/bin/bash

declare -a account_ids=("00000000" "11111111")
declare -a environments=("env1" "env2")
echo "AWS Login"

#check if keyring is locked then unlock it
LOCKED=`python -c "import gnomekeyring;print gnomekeyring.get_info_sync(None).get_is_locked()"`

if [ "$LOCKED" == "True" ]; then
  read -rsp "Keyring Password: " pass; python -c "import gnomekeyring;gnomekeyring.unlock_sync(None, '$pass');"
fi

# Update AD Password
if [ "$1" == "-p" ]; then
  echo ""
  read -rsp "AD Password: " password
  PASSWORD_OPTION="--password=$password"
fi

echo ""

for (( i=0; i<${#account_ids[@]}; i++ ));
do
  echo "Authenticating profile: team-${environments[$i]}"
  ~/bin/saml2aws login --force --skip-prompt\
                 --profile="team-${environments[$i]}" \
                 --session-duration=43200 \
                 --role="arn:aws:iam::${account_ids[$i]}:role/somerole" \
                 $PASSWORD_OPTION
done

