# bash-journal

Simple bash script for daily markdown journaling with automatic Git synchronization.

## What It Does

Automated Daily Entries: Creates journal entries with date-based filenames (DD-MM-YYYY.md).
Git Integration: Automatic commits and pushes to your GitHub repository.
Smart File Handling: Opens existing entries for editing or creates new ones.
Activity Logging: Tracks all journal activities in a local log file.
Flexible Editor Support: Uses your preferred editor (defaults to nano).
Empty Entry Protection: Prevents committing empty journal entries.

## Quick Start

**1. Download:**
```bash
git clone https://github.com/TraXxx1/bash-journal
cd bash-journal
```

**2. Make the script executable:**
```bash
.chmod +x journal.sh
```

**3. Setup (first time only):**
```bash
./journal.sh init git@github.com:yourusername/your-journal-repo.git
```

**4. Start journaling:**
```bash
./journal.sh
```

That's it! Write your thoughts, save, and it's automatically backed up to GitHub.

## Commands

| Command | What it does |
|---------|-------------|
| `./journal.sh` | Write today's entry |
| `./journal.sh init <repo-url>` | Setup with your GitHub repo |
| `./journal.sh -h` | Show help |

## Example Output

After setup, you'll have this structure in `~/journalrepo/`:

```
~/journalrepo/
├── .git/
├── .gitignore
├── journal.log          # Your activity log (local only)
├── 26-07-2025.md        # Today's entry
├── 25-07-2025.md        # Yesterday's entry
└── 24-07-2025.md        # Previous entries...
```

**Sample journal entry (26-07-2025.md):**
```markdown
# July 26, 2025

Great day today! Finally published my bash-journal script.

```

**Your activity log (journal.log):**
```
2025-07-26 09:15:23 - Added entry for 26-07-2025
2025-07-25 18:30:45 - Modified entry for 25-07-2025
2025-07-24 20:12:10 - Added entry for 24-07-2025
```

## Requirements

- Bash shell
- Git installed and configured
- GitHub repository (can be private)
- SSH key for GitHub
- Any text editor (nano, vim, etc.)

## Setup Your GitHub Repo

1. Create a new repository on GitHub
2. Don't initialize it (the script does this)
3. Copy the SSH URL for the init command


## Troubleshooting

**"Repository already exists"** → You're set up! Just run `./journal.sh`

**"Can't push to GitHub"** → Check your SSH key: `ssh -T git@github.com`

**Editor won't open** → Try: `export EDITOR=nano`

## License

MIT - Use it however you want!

---

**Happy journaling!** 📝
