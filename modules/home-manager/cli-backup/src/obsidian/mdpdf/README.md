# obsidian-mdpdf
A convenient Markdown to PDF converter built for a zettelkasten Obsidian workflow.

Obsidian makes it hard for users. You cannot export files along with their linked files.
Let's say you wanted to print a whole map of content. You would have to export each file individually, which is insanity.

This tool does just what you expect : it reads the file you want to export, finds linked files, and exports them as well.
It then nicely merges all of them into a single pdf file that you can easily print.

This script only works if you use [[wiki links]]. Which I think is the case for most Obsidian users.

## Dependencies
- [pandoc](https://pandoc.org/)
- [obsidian-export](https://github.com/zoni/obsidian-export)
- pdfunite (part of *poppler*)

## Usage
*You can optionally add the script to your local binaries*

```
mdpdf [target] [exported_file_name]
```

Example :
```
mdpdf /home/iq/library/somenote printable_notes
```

Omit the *".pdf"* file extension when entering the desired exported file name.

## How it works

1. Reads through your note.
2. Looks for [[wiki links]].
3. Finds a file that matches the link.
4. Exports that file.
5. Merges all the files into a single pdf file.

It is quite a simple script.

Will probably not add any features, for it already does what I need it to do.
I am not a developer by any means, feel free to tweak it so it fits your needs.
