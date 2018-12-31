#!/usr/bin/env bash
source ~/.backupwprc

LOG="/var/log/borg/backup-drone.log"
REPOSITORY="ssh://${BACKUP_USER}@${BACKUP_USER}.your-storagebox.de:23/${BACKUP_FOLDER}"

# Output to log
exec > >(tee -i ${LOG})
exec 2>&1

echo "###### BACKUP STARTED: $(date) ######"

echo "Transferring data..."
borg create -v --stats                       \
    $REPOSITORY::`date '+%Y-%m-%d_%H:%M:%S'` \
    /mnt/data/drone

echo "###### BACKUP FINISHED: $(date) ######"