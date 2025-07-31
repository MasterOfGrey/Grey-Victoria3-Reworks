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

# Convert any ANSI/Windows-1252 or ISO-8859-1 to UTF-8, strip BOM if present:
# 1) Prepare a UTF-8 version
desc_file=$(mktemp)
enc=$(file --mime-encoding "$3" | cut -d: -f2 | tr -d ' ')
if [[ $enc == utf-8 || $enc == us-ascii ]]; then
  cp "$3" "$desc_file"
else
  iconv -f WINDOWS-1252 -t UTF-8 "$3" >"$desc_file" \
    || { echo "? iconv failed" >&2; exit 1; }
fi
# 2) Strip BOM if present (byte-wise)
head_bytes=$(head -c3 "$desc_file" | od -An -tx1 | tr -d ' \n')
if [[ $head_bytes == "efbbbf" ]]; then
  tail --bytes=+4 "$desc_file" >"${desc_file}.nobom"
  mv "${desc_file}.nobom" "$desc_file"
fi

# Check mod description
if [ -f "$desc_file" ]; then
  description=$(sed -e ':a;N;$!ba' -e 's/\r//g' -e 's/\n/\\n/g' -e 's/\\/\\\\/g' -e 's/"/\\"/g' "$desc_file")
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
if [ -f "$desc_file" ]
then
	printf '\t"description" "%s"' "$description" >> workshop.vdf
	printf '\n' >> workshop.vdf
fi
printf '}\n' >> workshop.vdf

rm -f "$desc_file"

cat workshop.vdf