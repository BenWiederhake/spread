# In case you want to deploy to a chroot or a temporary directory:
DESTDIR?=/
# If you really insist, you can supply a different config-dir.
# This will be implanted into restic-params.sh.
RESTIC_CONFIG_DIR?=

all:
	@echo "Specify either target 'export', 'export-templates' or target 'import'."
	@echo "Alternatively, copy the files by hand."
	@exit 1

.i-want-to-deploy-it-on-this-account:
	@echo "Do you really want to deploy it for this account?"
	@echo "Call 'touch' on the file, then."
	@exit 1

say:
	true "DESTDIR is ${DESTDIR}, jo."

export-all: export-static export-templates

export-static: .i-want-to-deploy-it-on-this-account
	@echo "Note that you also need ~/bin on your \$$PATH"
	install -D -t "${HOME}/bin" src/restic-check-age src/restic-heimdal src/restic-last-backup src/restic-run-backup

export-templates: .i-want-to-deploy-it-on-this-account
	# FIXME: params  MUST REPLACE "export RESTIC_CONFIG_DIR"
	# FIXME: known_hosts
	# FIXME: exclude.lst
	@echo "Not implemented."
	@exit 1

import:
	@echo "Not importing \$${HOME}/.ssh/known_hosts"
	@echo "Not importing \$${RESTIC_CONFIG_DIR}/.ssh/exclude.lst"
	@echo "Not importing \$${HOME}/.ssh/params"
	cp -t src/ ~/bin/restic-check-age ~/bin/restic-heimdal ~/bin/restic-last-backup ~/bin/restic-run-backup
