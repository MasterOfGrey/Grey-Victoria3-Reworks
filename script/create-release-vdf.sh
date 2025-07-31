#!/bin/bash

# Check mod directory
if [ -d "$1" ]
then
  mod_path=$(realpath "$1")
else
  printf 'Missing Mod Directory'
  printf '\n'
  printf 'Usage: ./create-release-vdf.sh MOD_DIR [MOD_ID] DESC_FILE'
  exit 1
fi

title=$(grep -Po '(?<=\s\"name\"\s:\s\").+(?=\",)' "$mod_path/.metadata/metadata.json")

# Read mod id
if [ -n "$2" ]
then
  mod_id="$2"
else
  mod_id='0'
fi

# Check mod description
if [ -f "$3" ]; then
  description=$(sed -e ':a;N;$!ba' -e 's/\r//g' -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\n/\\n/g' "$3")
# slurp entire file			-e ':a;N;$!ba'
# remove any stray CR (^M)	-e 's/\r//g'
# escape backslashes		-e 's/\\/\\\\/g'
# escape double-quotes		-e 's/"/\\"/g'
# escape newlines			-e 's/\n/\\n/g'
#  echo ">>> DEBUG: first 200 chars of desc:" >&2
#  printf '%s' "$description" | cut -c1-200 >&2
else
  printf 'Missing Steam description'
  printf '\n'
fi
# If you need to test with a blank description:
#description=""

# After building $description (with all backslashes, quotes and newlines escaped):
# 1) Measure its length in characters
char_len=$(printf '%s' "$description" | wc -m)
echo ">>> DEBUG: escaped description length = $char_len characters" >&2

# 2) Define your max in characters (e.g. 8000)
MAX_CHARS=8000

# 3) If it’s too long, truncate to the first $MAX_CHARS characters
if [ "$char_len" -gt "$MAX_CHARS" ]; then
  echo ">>> WARNING: description too long (${char_len} > ${MAX_CHARS}), truncating" >&2
  # cut -c works on characters
  description=$(printf '%s' "$description" | cut -c1-"$MAX_CHARS")
  # (optionally append an ellipsis)
  # description="${description}…"
fi



# Clean up old file
printf '' > workshop.vdf

printf '"workshopitem"' >> workshop.vdf
printf '\n' >> workshop.vdf
printf '{' >> workshop.vdf
printf '\n' >> workshop.vdf
printf '\t"appid" "529340"' >> workshop.vdf
printf '\n' >> workshop.vdf
printf '\t"publishedfileid" "%s"' "$mod_id" >> workshop.vdf
printf '\n' >> workshop.vdf
printf '\t"contentfolder" "%s"' "$mod_path" >> workshop.vdf
printf '\n' >> workshop.vdf
printf '\t"previewfile" "%s/thumbnail.png"' "$mod_path" >> workshop.vdf
printf '\n' >> workshop.vdf
printf '\t"title" "%s"' "$title" >> workshop.vdf
printf '\n' >> workshop.vdf
if [ -f "$3" ]
then
	printf '\t"description" "%s"' "$description" >> workshop.vdf
	printf '\n' >> workshop.vdf
fi
printf '}\n' >> workshop.vdf

cat workshop.vdf