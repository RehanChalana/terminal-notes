#!/bin/bash

NOTES_DIR="./notes"
CONFIG_FILE="./c"

# -p ensures that script does not throws an error if directory already exists.
# it also ensures that parent directories are created if they don't already exist.
mkdir -p "$NOTES_DIR"

if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else 
    EDITOR="nano"
fi

# $0 is a speacial variable that stores the filename
show_help() {
    echo "Usage: $0 [command] [note_name or keyword]"
    echo ""
    echo "Commands:"
    echo "  new <note_name>     Create or edit a note"
    echo "  list                List all notes"
    echo "  delete <note_name>  Delete a note"
    echo "  search <keyword>    Search notes for a keyword"
    echo "  sync                Commit & push notes to GitHub"
    echo "  config <editor>     Set default editor (e.g., vim, nano, micro)"
}

show_help

