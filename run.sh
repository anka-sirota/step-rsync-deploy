#!/bin/sh

# host option
if [ -z "$WERCKER_RSYNC_DEPLOY_HOST" ]
then
    fail 'missing host option, please add this the rsync-deploy step in wercker.yml'
fi

# directory option
if [ -z "$WERCKER_RSYNC_DEPLOY_DIRECTORY" ]
then
    fail 'missing directory option, please add this the rsync-deploy step in wercker.yml'
fi

# user option
remote_user="ubuntu"
if [ -n "$WERCKER_RSYNC_DEPLOY_USER" ]; # Check $WERCKER_BUNDLE_INSTALL exists and is not empty
then
    remote_user="$WERCKER_RSYNC_DEPLOY_USER"
fi
info "using user $remote_user"

# key option
rsync_command="ssh -o BatchMode=yes" # Batchmode to prevent it from waiting on user input
if [ -n "$WERCKER_RSYNC_DEPLOY_SSHKEY" ]
    rsync_command="$rsync_command -i $WERCKER_RSYNC_DEPLOY_SSHKEY"

source_dir="./"

sync_output=$(rsync -urltv --delete --rsh="$rsync_command" "$source_dir" "$remote_user@$WERCKER_RSYNC_DEPLOY_HOST:$WERCKER_RSYNC_DEPLOY_DIRECTORY")
if [[ $? -ne 0 ]];then
    warning $sync_output
    fail 'rsync failed';
else
    success "finished rsync synchronisation"
fi