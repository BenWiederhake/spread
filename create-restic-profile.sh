#!/bin/sh

set -e

if [ $# -ne 1 ] ; then echo "Usage: $0 PROFILE_NAME" ; echo "Hint: 'default' is a good profile name." ; exit 1 ; fi
PROFILE_NAME="$1"
shift
RESTIC_CONFIG_DIR="${HOME}/.config/restic-run/${PROFILE_NAME}"

if [ -d "${RESTIC_CONFIG_DIR}" ]
then
    echo "Profile at ${RESTIC_CONFIG_DIR} already exists.  Abort!"
    exit 1
fi

cp -a profile-template/ "${RESTIC_CONFIG_DIR}"

chmod go-rx "${RESTIC_CONFIG_DIR}"
chmod go-r "${RESTIC_CONFIG_DIR}/params"
sed -i -e "s<your_repository_name_here<$PROFILE_NAME<" "${RESTIC_CONFIG_DIR}/params"

echo "Success.  You can now put your details into ${RESTIC_CONFIG_DIR}/params"
echo "Also look at the other files there."
