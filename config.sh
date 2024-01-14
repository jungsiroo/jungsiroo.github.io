#!/bin/bash

file="_config.yml"
line_number=113

if [ "$1" == "deploy" ]; then
    sed -i "${line_number}s/^/#/" "$file"
    echo "DEPLOY JOB DONE"
elif [ "$1" == "server" ]; then
    sed -i "${line_number}s/^#//" "$file"
    echo "SERVER JOB DONE"
    bundle exec jekyll serve
else
    echo "Usage: $0 [deploy | server]"
fi
