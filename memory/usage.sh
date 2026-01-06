#!/bin/bash

THRESHOLD=80

df -h | grep '^/dev/' | while read line; do
  usage=$(echo $line | awk '{print $5}' | sed 's/%//g')
  mount=$(echo $line | awk '{print $6}')

  if [ "$usage" -ge "$THRESHOLD" ]; then
    echo "WARNING: $mount usage is at ${usage}%"
  else
    echo "OK: $mount usage is at ${usage}%"
  fi
done

