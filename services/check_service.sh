#!/bin/bash

SERVICE="nginx"

if systemctl is-active --quiet $SERVICE; then
  echo "OK: $SERVICE is running"
else
  echo "CRITICAL: $SERVICE is down, restarting..."
  systemctl restart $SERVICE

  if systemctl is-active --quiet $SERVICE; then
    echo "RECOVERED: $SERVICE restarted successfully"
  else
    echo "FAILED: $SERVICE could not be restarted"
  fi
fi

