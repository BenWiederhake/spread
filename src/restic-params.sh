# Sourced by all restic-* scripts.

# Given out by the owner of heimdal:
export RESTIC_REPOSITORY_USER="fool"  # FIXME

# Will be part of a filesystem path, so don't go crazy.
export RESTIC_REPOSITORY_NAME="main"

# The password.
export RESTIC_PASSWORD="1234"  # FIXME

export RESTIC_CONFIG_DIR="${HOME}/.config/restic-run-backup"

# '10000' would mean that from a repository of size 30G, restic-run-backup
# verifies about 3M after each successful backup.  Note that some metadata
# is always read and verified.
export RESTIC_READ_SUBSET_FRACTION=10000

export RESTIC_REPOSITORY="sftp://backup-${RESTIC_REPOSITORY_USER}@restic-server:/writable/${RESTIC_REPOSITORY_NAME}"
