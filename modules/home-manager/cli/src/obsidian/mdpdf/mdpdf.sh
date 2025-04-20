#!/bin/bash

# This script goes through a markdown file (well any text file) and exports
# any linked files (in the same directory) to PDF format.

# I created that script because Obsidian makes it really hard to export multiple
# files when you have a Zettelkasten workflow

# Usage : ./mdpdf.sh [file_name] [export_name]

file=$1 # file name
export_name=$2 # name of the exported pdf file (don't add the ".pdf" extension)
directory="/home/iq/notes_export" # export directory
vault_path=/home/iq/library/3\ BRAIN\ CELLS/
base_name=$(basename "${file}")
i=1

# Creates the target directory if it does not already exist
mkdir -p "$directory"

# Copy origin file to the directory
# Numerical values are assigned to merge them in the righ order
# remove the "0.md" to conserve orignal file name
cp "$file" "$directory/0.md"


# loops through the file
while read line; do

  # we verify if line contains a link
  if [[ "$line" == *"[["* ]]; then

    # gets what's inside [[links]]
    linked="$(echo "$line" | grep -o -P '(?<=\[\[).*(?=\]\])')"

    # remove "$i.md" to conserve orignal file name
    (cd "$vault_path" && cp "$linked.md" "$directory/$i.md")

  fi

  i=$((i+1))

done < "$file" # quotes around $file to avoid 'ambiguous redirect' error


# Exporting Osbidian-specific syntax to regular markdown
obsidian-export "$directory/" "$directory/" > /dev/null 2>&1

# Converting those markdown files to pdf
(cd "$directory" && \find ./ -iname "*.md" -type f -exec sh -c 'pandoc -t ms "${0}" -o "${0%.md}.pdf"' {} \; && rm *.md) > /dev/null 2>&1


# Merging all notes into one single pdf for printing purposes
# It then deletes all the pdf files to only keep the merged one
(cd "$directory" && pdfunite *.pdf "$export_name.pdf" && rm [0-9]*.pdf)


