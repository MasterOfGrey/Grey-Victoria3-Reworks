#!/bin/bash

IFS=';'
mod_data=($1)
unset IFS

echo "mod-name=${mod_data[0]}" >> "$GITHUB_OUTPUT"
echo "mod-id=${mod_data[1]}" >> "$GITHUB_OUTPUT"