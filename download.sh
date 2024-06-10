#!/bin/bash
# ------------------------------------------------------------------------
# [sftobias] Download user dataset
#            Automated process for downloading user dataset from zenodo
# ------------------------------------------------------------------------
# Download file based on RecordID from environment variable

record_id="$RECORD_ID"

check_command="df -h -x tmpfs -x devtmpfs | grep rshare"

check_filesystem() {
    eval "$check_command" > /dev/null 2>&1
    return $?
}

while true; do
    if check_filesystem; then
        eval echo "rshare correctly mounted at /storage"
        break
    else
        eval echo "waiting for rshare to be mounted at /storage"
        sleep 3
    fi
done

# Check if /storage is accessible
if [ "$(ls /storage 2>&1)" = "ls: reading directory '/storage': Input/output error" ]; then
    echo "Error: /storage is not accessible"
    exit 1
fi

data_dir="/storage/ai4os-storage/zenodo/$record_id"


if [ "$FORCE_PULL" = true ] ; then
    echo "FORCE_PULL set to true, deleting data dir"
    rm -rf $data_dir
fi

zenodo_get -r $record_id -o $data_dir --keep

# `--keep` in principle should avoid overwriting the changes but it does not seem to be
# working.
# ref: https://github.com/dvolgyes/zenodo_get/issues/29