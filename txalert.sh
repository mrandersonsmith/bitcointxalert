#! /bin/bash
# ./txalert.sh <txhash> <# of confirmations desired,no input = 1>
# you need to install jq json parser, sudo apt-get install jq
# you also need a file to play for the alert the doorbell.wav is not included

confirmstatus=0
if [[ -z $2 ]]; then
  confirmations=1
else
  confirmations=$2  
fi
while [[ $confirmstatus < $confirmations ]]; 
do
  confirmstatus=$(curl -s https://chainflyer.bitflyer.jp/v1/tx/$1 | jq -r .confirmed)
  if [[ $confirmstatus > $confirmations ]]; then
    echo "Transaction is already confirmed with $confirmstatus confirmations"
    aplay -q doorbell.wav
    exit 1
  fi

  date
  echo "Transaction has $confirmstatus of $confirmations confirmations"
  if [[ $confirmstatus < $confirmations ]]; then
   sleep 60
  else
    aplay -q doorbell.wav
  fi
done
