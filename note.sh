#!/bin/bash

NOTES_DIR="./notes"
CONFIG_FILE="./config"

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

# $1 is the first command line argument passed to the shell script
case "$1" in 
    new)
        # -z returns true if string is empty
        [[ -z "$2" ]] && echo "Note name required." && exit 1
        mkdir -p "$(dirname "$NOTES_DIR/$2")"
        $EDITOR "$NOTES_DIR/$2.md"
        ;;
    list)
        # sed command is removing the $NOTES_DIR prefix from the results 
        # So we get only relative paths and file names in the result
        find "$NOTES_DIR" -type f -name "*.md" | sed "s|$NOTES_DIR/||"
        ;;
    delete)
        [[ -z "$2" ]] && echo "Note name required." && exit 1
        NOTE_PATH="$NOTES_DIR/$2.md"
        if [[ -f "$NOTE_PATH" ]]; then
            rm "$NOTE_PATH"
            echo "Deleted $2"
        else 
            echo "Note not found."
        fi
        ;;
    search)
        [[ -z "$2" ]] && echo "Keyword required." && exit 1
        # -rn --> recursive and include line number
        grep -rn --color=always "$2" "$NOTES_DIR"
        ;;
    sync)
        if [[ -z "$GITHUB_TOKEN" || -z "$GITHUB_REPO" ]]; then
            echo "Github token or repo not set in the config"
            exit 1
        fi

        git pull "https://$GITHUB_TOKEN@github.com/$GITHUB_REPO.git"
        git add .
        git commit -m "Sync notes: $(date)" || echo "No changes to commit"
        git push "https://$GITHUB_TOKEN@github.com/$GITHUB_REPO.git"
        ;;
    help)
        show_help
        ;;
esac




