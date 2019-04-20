# Sourced by all restic-* scripts.

# Given out by the owner of heimdal:
export RESTIC_REPOSITORY_USER="fool"  # FIXME

# Will be part of a filesystem path, so don't go crazy.
export RESTIC_REPOSITORY_NAME="main"

# The password.
export RESTIC_PASSWORD="1234"  # FIXME

export RESTIC_CONFIG_DIR="${HOME}/.config/restic-run-backup"

TAB='	'
# Which files/directories to back up.
# TAB-spearated!  Paths which contain a TAB are impossible to escape:
# https://stackoverflow.com/q/1724032/3070326
#export RESTIC_BACKUP_FILES_DIRS="${RESTIC_CONFIG_DIR}${TAB}${HOME}/workspace${TAB}/super/important/file.gz"
export RESTIC_BACKUP_FILES_DIRS="/dev/null"  # FIXME

# '1000' would mean that from a repository of size 30G, restic-run-backup
# verifies about 30M after each successful backup.  Note that some metadata
# is always read and verified.
export RESTIC_READ_SUBSET_FRACTION=10000

export RESTIC_REPOSITORY="sftp://backup-${RESTIC_REPOSITORY_USER}@restic-server:/writable/${RESTIC_REPOSITORY_NAME}"
