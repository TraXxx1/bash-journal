#!/bin/bash
set -euo pipefail

HOME_DIR="$HOME"
JOURNAL_DIR="$HOME_DIR/journalrepo"
LOG_FILE="$JOURNAL_DIR/journal.log"
DATE=$(date +"%d-%m-%Y")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
EDITOR="${EDITOR:-nano}"


log_activity() {
    echo "$TIMESTAMP - $1" >> "$LOG_FILE"
}

init_journal() {
	local repo_url="$1"

    if [ -d "$JOURNAL_DIR" ] && [ -d "$JOURNAL_DIR/.git" ]; then
        echo "Error: Git repository already exists at $JOURNAL_DIR"
        exit 1
    fi

    mkdir -p "$JOURNAL_DIR"
    cd "$JOURNAL_DIR"

    git init --quiet
    git remote add origin "$repo_url"

    echo "journal.log" > .gitignore
    git add .gitignore
    git commit --quiet -m "Initial commit: added .gitignore"
    
    log_activity "Created Git repository in $JOURNAL_DIR"

    # Attempt to push to master or main
    if git push --quiet origin master 2>/dev/null || git push --quiet origin main 2>/dev/null; then
        echo "Journal repository created successfully at $JOURNAL_DIR"
        echo "Initial commit pushed to GitHub"
    else
        echo "Repository created locally but couldn't push to GitHub"
        echo "Make sure the remote repository exists on GitHub"
    fi
}


handle_journal_entry() {
    if [ ! -d "$JOURNAL_DIR" ]; then
        echo "Error: Journal repository not found!"
        echo "Run: $0 init"
        exit 1
    fi

    cd "$JOURNAL_DIR"

    if [ -f "$DATE.md" ] && git ls-files --error-unmatch "$DATE.md" >/dev/null 2>&1; then
        echo "Opening existing entry for $DATE..."
	sleep 3	
	"$EDITOR" "$DATE.md"
        git add "$DATE.md"

        if git diff --cached --quiet; then
            echo "No changes detected. Nothing to commit."
            exit 0
        fi

        git commit --quiet -m "Modified $DATE's entry"
        git push --quiet origin master
        log_activity "Modified entry for $DATE"
        echo "$DATE.md has been modified and pushed to GitHub."
    else
        touch "$DATE.md"
 	echo "Creating new entry for $DATE..."
 	sleep 3
	"$EDITOR" "$DATE.md"

        if [ ! -s "$DATE.md" ]; then
            echo "Entry is empty. Skipping commit."
            rm -f "$DATE.md"
            exit 0
        fi

        git add "$DATE.md"
        git commit --quiet -m "Added $DATE's entry"
        git push --quiet origin master
        log_activity "Added entry for $DATE"
        echo "Today's entry has been added and pushed to GitHub."
    fi
}

show_usage() {
    echo "Usage: $0 [init[repo-url]]"
    echo ""
    echo "Commands:"
    echo "  (no args)            - Open today's journal entry"
    echo "  init [repo-url]      - Initialize journal repository (Github URL)"
    echo ""
    echo "Examples:"
    echo "  $0         # Open today's entry"
    echo "  $0 init    # Prompt for GitHub repo URL"
    echo "  $0 init git@github.com:user/repo.git  # Use provided GitHub repo URL"
} 

main() {
    case "${1:-}" in
        "")
            handle_journal_entry
            ;;
        init)
            if [[ -z "${2:-}" ]]; then
                read -rp "Enter GitHub repo URL (e.g. git@github.com:user/repo.git): " GITHUB_REPO
                if [[ -z "$GITHUB_REPO" ]]; then
                    echo "Error: Repository URL is required to initialize."
                    exit 1
                fi
            else
                GITHUB_REPO="$2"
            fi
            init_journal "$GITHUB_REPO"            
	    ;;
        -h|--help|help)
            show_usage
            ;;
        *)
            echo "Error: Unknown parameter '$1'"
            show_usage
            exit 1
            ;;
    esac
}


if [ $# -gt 2 ]; then
    echo "Error: Too many parameters"
    show_usage
    exit 1
fi

main "${1:-}" "${2:-}"
