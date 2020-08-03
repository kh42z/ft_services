#!/bin/sh
EXITED=$(supervisorctl status all| grep -c "EXITED")
if [ $EXITED -gt 0 ]
then
  exit 1
fi
