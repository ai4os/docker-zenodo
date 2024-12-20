#!/bin/bash
# ------------------------------------------------------------------------
# [sftobias] Download user dataset
#            Automated process for downloading user dataset from zenodo
# ------------------------------------------------------------------------
# Download file based on RecordID from environment variable

doi="$DOI"

# Check if the "DOI" variable is indeed a DOI or an URL
# If it's an URL, make it path safe

if [[ $doi == http* ]]; then
    doi_path="$(echo "$doi" | sed -E 's|http(s)?://||; s|^www.||; s|/$|| ; s|/|-|g')"
else
    doi_path="$doi"
fi

# Wait until storage is mounted to proceed

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

# Download dataset to proper dir

data_dir="/storage/ai4os-storage/datasets/$doi_path"

if [ "$FORCE_PULL" = true ] ; then
    echo "FORCE_PULL set to true, deleting data dir"
    rm -rf $data_dir
fi

mkdir -p $data_dir
datahugger "$doi" "$data_dir" |& tee "$data_dir/ai4os.log"

# We exit 0 because we don't want to fail the whole deployment because a dataset could
# not be downloaded. Especially because users might add dataset URLs that are not
# supported by Datahugger. So we exit 0, and let users read in the log why their
# download failed.
# Making the Dashboard check if a URL is supported by Datahugger seems a PITA because
# we would need to constantly keep the Dashboard updated with Datahugger's regexps
exit 0
