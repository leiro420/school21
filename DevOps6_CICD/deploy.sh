#!/bin/bash
set -e

REMOTE_USER="janellam-pc"
REMOTE_HOST="192.168.56.101"
SSH_KEY="/home/gitlab-runner/.ssh/id_ed25519_deploy"
LOCAL_ARTIFACT="artifacts/bin/DO"  
REMOTE_TMP="/tmp/DO"
REMOTE_DEST="/usr/local/bin/DO"

if [ ! -f "$LOCAL_ARTIFACT" ]; then
    echo "Error: file $LOCAL_ARTIFACT not found!"
    exit 1
fi

echo "Copy $LOCAL_ARTIFACT to $REMOTE_HOST:$REMOTE_TMP"
scp -i "$SSH_KEY" "$LOCAL_ARTIFACT" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_TMP"

echo "Install file to $REMOTE_DEST"
ssh -i "$SSH_KEY" "$REMOTE_USER@$REMOTE_HOST" \
    "sudo mv $REMOTE_TMP $REMOTE_DEST && sudo chmod +x $REMOTE_DEST"

echo "Deploy completed"
